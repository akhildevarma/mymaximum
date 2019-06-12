class Inquiry < ActiveRecord::Base
  include ActionView::Helpers
  extend Enumerize

  acts_as_taggable rescue nil

  enumerize :status,
            in: [:research, :response_formulation, :review, :complete],
            default: :research,
            scope: true
  enumerize :project_types,
            in: {none: 0, drug_monograph:1, class_review: 2, drug_use_evaluation: 3, therapeutic_interchange: 4, beyond_use_dating: 5, other: 6 },
            default: :none,
            scope: true

  enumerize :turnaround_time,
            in: { asap: 1, one_day: 2, a_few_days: 3, a_week: 4, not_urgent: 5 },
            default: :not_urgent

  belongs_to :submitter, class_name: 'User', inverse_of: :submitted_inquiries
  belongs_to :assignee, class_name: 'User', inverse_of: :assigned_inquiries
  has_many :survey_responses, foreign_key: :inquiry_id, dependent: :destroy
  has_one :intervention, dependent: :destroy
  has_many :summary_tables, -> { order('created_at ASC') }, inverse_of: :inquiry

  has_many :comments,->{ where(deleted: false) }, class_name: 'Comment', foreign_key: 'referenceable_id'
  has_many :documents,->{ where('file_file_name is not NULL and referenceable_type = ?', 'Inquiry').order(created_at: :desc)}, class_name: 'Document',foreign_key: 'referenceable_id'
  has_many :images,->{ where('image_file_name is not NULL and referenceable_type = ?', 'Inquiry').order(created_at: :desc)}, class_name: 'BlogImage',foreign_key: 'referenceable_id'
  validates :question, presence: true, unless: :blog_post?
  validates :submitter_id, presence: true
  validates :turnaround_time, presence: true, unless: :blog_post?
  validates :title, uniqueness: { case_sensitive: false }, presence: true, allow_nil: true

  before_save :reset_assignee, if: :status_changed?
  before_create :set_assignee, unless: :blog_post?
  before_create :assign_slug
  before_create :update_hidden_sections, if: :asap_inquiry?
  after_create :update_assignee, unless: :blog_post?
  before_save :assign_slug, if: :title_changed?

  has_one :guid, class_name: 'Guid', foreign_key: 'referenceable_id'

  has_paper_trail meta: {
    inquiry_assignee_id: :assignee_id,
    inquiry_status: :status
  }


  scope :order_by_priority, -> { order('turnaround_time ASC, created_at ASC') }
  scope :with_background, -> { where("background <> '' or review_of_clinical_guidelines <> '' or review_of_meta_analyses <> '' or  review_of_review_articles <> '' or review_of_other_tertiary_literature <> '' ") }
  scope :publishable, -> { closed.with_background.where(published_at: nil).where('completed_at is not NULL').order('completed_at DESC') }
  scope :published, -> { where.not(published_at: nil, title: nil).order('published_at DESC') }
  scope :public_inquiries, -> { where.not(published_at: nil, title: nil, view_everyone: false).order('published_at DESC') }
  scope :open, -> { without_status(:complete) }
  scope :closed, -> { with_status(:complete) }
  scope :non_blog, -> { where(inquiry_type: 'non_blog') }
  scope :received, -> { non_blog.where('received_at IS NOT NULL') }
  scope :reverse_chronological_order, -> {
    order(created_at: :desc)
  }
  scope :new_today, -> {
    where(created_at: Time.now.beginning_of_day..Time.now.end_of_day)
  }
  scope :last_received_by,
        ->(user) { non_blog.where(submitter_id: user.id).received.order('updated_at DESC').first }

  scope :per_user_last_30,
    -> { non_blog.where('created_at >= :last_30', last_30: DateTime.now - 30.days).count.fdiv(User.count).round(2) }

  scope :inactive_for_last_3hours,
    -> { non_blog.where.not(status: 'complete', assignee_id: nil).where('updated_at <= :last_3hours', last_3hours: 3.hours.ago) }

  scope :new_by_month,
    -> { all.non_blog.order('created_at ASC').group_by { |t| t.created_at.beginning_of_month.strftime("%b %y") }.map { |month, collection| [month,collection.count] } }

  scope :per_team_last_30, -> do
    Hash[
      Team.all.select(&:signup_flow_active?).collect { |team|
        [
          team.name.downcase.gsub(' ','_').to_sym, {
            total_inquiries: team_total = Inquiry.\
              where('submitter_id IN (:team_members_list)', team_members_list: team.users.map(&:id) ).\
              where('created_at >= :last_30', last_30: DateTime.now - 30.days).\
              count,
            inquiries_per_member: team_total.fdiv(team.users.count).round(2)
          }
        ]
      }
    ]
  end

  scope :per_team, ->(team) {
    where('submitter_id IN (:team_members_list)', team_members_list: team.users.map(&:id) )
  }


  scope :unread, -> {
    where(read_at: nil).
    non_blog
  }

  scope :asked_by_me, ->(user, limit = 5) {
    where(submitter_id: user.id)
      .non_blog
      .reverse_chronological_order
      .limit(limit)
  }

  scope :unread_for_user, ->(user) {
    where(submitter_id: user.id).unread
  }

  scope :all_list, ->(user) {
    where("(published_at IS NOT NULL and (submitter_id IN (:team_members_list) or view_everyone = true)) or submitter_id = #{user.id}", team_members_list: user.in_team? ? (user.team.users.map(&:id)-[user.id]) : [user.id]).
    non_blog.
    order('published_at DESC')
  }

  scope :last_inquiries_by_timeframe,
    ->(timeframe, turnaround) {
      where('created_at >= :last and completed_at is not NULL',last: DateTime.now - timeframe.days).\
      where(status: 'complete',turnaround_time: turnaround).\
      non_blog.
      map { |inq| ((inq.completed_at-inq.created_at)).round }
    }

  scope :last_all_inquiries_except_asap,
    ->(timeframe) {
      where('created_at >= :last',last: DateTime.now - timeframe.days).\
      where("status = 'complete' and turnaround_time!=1 and completed_at is not NULL").\
      non_blog.
      map { |inq| ((inq.completed_at-inq.created_at)).round(2) }
    }

  scope :all_completed_inquiries,
    -> {
      where("status = 'complete' and completed_at is not NULL").\
      non_blog.
      map { |inq| {version: inq.versions.where({inquiry_status: 'response_formulation'}).last, inquiry: inq} }.delete_if {|x| x[:version].nil? }
  }

  scope :completed_inquiries_by_turnarround,
    ->(timeframe, turnaround) {
      where('created_at >= :last',last: DateTime.now - timeframe.days).\
      where("status='complete' and turnaround_time = ? and completed_at is not NULL", turnaround).select('id,created_at,completed_at,question').
      non_blog
    }

  def self.send_response_overdue_reminders
    where(overdue_notification_sent_at: nil).
    where('created_at <= ?', Time.now-4.hours).
    non_blog.
    where.not(status: 'complete', assignee_id: nil).inject([]) do | overdue_inquries, inquiry|
      overdue_inquries << inquiry if inquiry.send_response_overdue_notification!
      overdue_inquries
    end
  end

  def no_rating_survey_responses
    survey_responses.where(rating: nil)
  end

  def self.to_csv(kwargs={})
    kwargs = kwargs || {}
    options = kwargs[:options] || {}
    CSV.generate(options) do |csv|
      csv << ['Email', 'First Name', 'Last Name', 'Question', 'Inquiry State', 'Created At', 'Turnaround Time', 'User Received At', 'Last Updated At']
      all.each do |inquiry|
        row = []
        user = inquiry.submitter
        row << user.email
        row << user.profile.try(:first_name)
        row << user.profile.try(:last_name)
        row << inquiry.question
        row << inquiry.status
        row << inquiry.created_at
        row << inquiry.turnaround_time
        row << inquiry.received_at
        row << inquiry.updated_at
        csv << row
      end
    end
  end

  def publishable?
    self.class.publishable.exists?(self.id)
  end

  def published?
    !!published_at
  end

  def set_read_at!
    return if self.read_at.present?
    self.update_attribute(:read_at, DateTime.now.utc)
  end

  def can_be_updated_by?(user)
    self.submitter == user
  end

  def open?
    !closed?
  end

  def closed?
    status.complete?
  end

  def assigned?
    assignee.present?
  end

  def self.statuses
    self.status.values
  end

  def passed_statuses
    self.class.statuses.slice(0..self.class.statuses.index(self.status))
  end

  def remaining_statuses
    self.class.statuses - passed_statuses
  end

  def received?
    self.received_at.present?
  end

  def send_response!
    self.status = :complete
    self.completed_at = DateTime.now
    save!
  end

  def active_comments(user)
    comments = self.comments
    comments = comments.where.not(id: FlaggedComment.where(user_id: user.id).select(:comment_id)) if user.present?
    comments.hash_tree(limit_depth: Comment::MAX_TREE_DEPTH)
  end

  def rating(user)
    response ||= survey_responses.where('responder_id =? and rating is not NULL', submitter.id).last
    @rating ||= response ? response.rating : 0
  end

  def mark_response_received!
    return if self.received?
    self.received_at = DateTime.now
    save!
  end

  def is_unread
    self.read_at == nil
  end

  def intervention_response?
    self.intervention_response
  end

  def mark_intervention_complete!
    return if self.intervention_response?
    self.intervention_resopnse = true
    save!
  end

  def related_inquiries
    find_related_tags # from acts_as_taggable
  end

  def copy_response_from(other_inquiry)
    self.researchable_question = other_inquiry.researchable_question
    
    if other_inquiry.has_background?
      self.review_of_clinical_guidelines = other_inquiry.read_attribute(:background)
    else
      self.review_of_clinical_guidelines = other_inquiry.review_of_clinical_guidelines
      self.review_of_meta_analyses = other_inquiry.review_of_meta_analyses
      self.review_of_review_articles = other_inquiry.review_of_review_articles
      self.review_of_other_tertiary_literature = other_inquiry.review_of_other_tertiary_literature
    end

    self.relevant_prescribing_info = other_inquiry.relevant_prescribing_info
    self.summary_tables = other_inquiry.summary_tables.map { |st| st.dup }
    self.save!
  end

  def self.tag_suggestions(query)
    self.tags_on(:tags).where('LOWER(name) LIKE LOWER(?)', "#{query}%").map(&:name)
  end

  def save_and_bill
    if valid?
      process_billing && save
    end
  end

  def dic_center_details
    right_version = versions.where({inquiry_status: 'response_formulation'}).last
    right_version = versions.first unless right_version
    _assigner = User.find_by_id(right_version.inquiry_assignee_id)
    dic_center = DIC_CENTERS[_assigner.email.split("@").last] if _assigner
    { center: dic_center ? dic_center : '' } 
  end
 
  def old_response_format
    [].tap do |output|
      output << custom_response_text unless custom_response_text.blank?
      output << "BACKGROUND\n\n#{background}" unless background.blank?
      output << "BACKGROUND REFERENCES\n\n#{background_references}" unless background_references.blank?
      output << "RELEVANT PRESCRIBING INFORMATION\n\n#{relevant_prescribing_info}" unless relevant_prescribing_info.blank?
      output << "PRESCRIBING INFORMATION REFERENCES\n\n#{relevant_prescribing_info_references}" unless relevant_prescribing_info_references.blank?
    end.join("\n\n\n")
  end

  def send_response_overdue_notification!
    if @response_overdue = (self.turnaround_time == 'asap' ? true : self.created_at <= Time.now-1.day )
      NotificationMailer::response_overdue(self).deliver_now
      update_attribute :overdue_notification_sent_at, Time.now.utc
    end
  end

  def background
    [ review_of_clinical_guidelines, review_of_review_articles, review_of_meta_analyses,review_of_other_tertiary_literature, read_attribute(:background) ].reject(&:blank?).join("\n\n\n")
  end

  def has_background?
    read_attribute(:background).present?
  end

  def project_type_related?
    self.project_types.present? && self.project_types!='none'
  end

  def blog_post?
    self.inquiry_type.present? && self.inquiry_type=='blog'
  end

  def asap_inquiry?
    turnaround_time.try :asap?
  end

  def set_assignee
    student = Student.next_assignee
    # There may will not always be a student to be assigned
    if student
      self.assignee = student.user
      student.update_attribute(:last_auto_assign, Time.now)
    end
  end

  def update_assignee
    assignee.student.assign!(self) if assignee && assignee.student
  end

  def self.inquiry_response_status
    Inquiry.includes(:submitter,:assignee).where.not(status: 'complete').each do |istatus|
      if (istatus.turnaround_time == 'asap' && istatus.created_at <= DateTime.now - 2.hours) || (istatus.turnaround_time != 'asap' && istatus.created_at <= DateTime.now - 1.days)
        InquiryResponseMailer::response_turnaround_time(istatus).deliver_now
        update_attribute :overdue_notification_sent_at, Time.now.utc
      end
    end
  end

  private

  def reset_assignee
    self.assignee = nil if status.try :review?
  end

  def update_hidden_sections
    self.hidden_sections = { summary_tables: true }
  end

  def assign_slug
    if title.present?
      # self.title = strip_tags( title.squeeze(' ') )
      self.title = sanitize title.html_safe
      self.slug = title.parameterize
    end
  end

  def process_billing
    return true unless submitter.should_be_billed_for_inquiries?
    biller = Billing::BillerFactory.create(submitter.payment_account)
    success = biller.process_inquiry_charge(self)
    self.errors[:billing] << biller.errors unless success
    success
  end

end
