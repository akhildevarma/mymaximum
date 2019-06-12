class SurveyResponse < ActiveRecord::Base
  extend Enumerize
  # include Workflow

  belongs_to :responder, class_name: 'User', foreign_key: :responder_id, inverse_of: :survey_responses
  belongs_to :inquiry, class_name: 'Inquiry', foreign_key: :inquiry_id, inverse_of: :survey_responses

  validates :appropriate, inclusion: [true, false], allow_nil: true
  validates :rating, inclusion: (1..5), numericality: true, allow_nil: true
  validates :recommendation_likelihood, inclusion: (1..5), numericality: true, allow_nil: true
  validates :intervention, inclusion: [true, false], allow_nil: true

  enumerize :workflow_state,
            in: [:new, :awaiting_answer_for_appropriate, :awaiting_answer_for_intervention, :awaiting_answer_for_what_was_intervention, :awaiting_answer_for_outcome, :complete],
            default: :new,
            scope: true

  scope :last_days, ->(no_days) {
    where('created_at < ? and initial= true  and inquiry_id is null and workflow_state = ? and sent_feedback_at is null',\
                         no_days.days.ago, :awaiting_answer_for_appropriate)
  }

  # workflow do
  #   state :new do
  #     event :begin, transitions_to: :awaiting_answer_for_appropriate
  #   end
  #   state :awaiting_answer_for_appropriate do
  #     event :record_answer, transitions_to: :awaiting_answer_for_intervention # event :record_answer, transitions_to: :awaiting_answer_for_rating
  #   end
  #   state :awaiting_answer_for_intervention do
  #     event :record_answer, transitions_to: :awaiting_answer_for_what_was_intervention, if: ->(survey) { survey.intervention? }
  #     event :record_answer, transitions_to: :dummy_state , if: -> (survey) { !survey.intervention? }
  #   end

  #   state :dummy_state

  #   state :awaiting_answer_for_what_was_intervention do
  #     event :record_answer, transitions_to: :awaiting_answer_for_outcome
  #   end
  #   state :awaiting_answer_for_outcome do
  #     event :record_answer, transitions_to: :complete
  #   end
    
  #   state :complete

  #   on_exit do |new_state, event, *args|
  #     logger.info "#{new_state}"
  #     logger.info "#{event.inspect}"
  #   end

  #   # on_transition do |from, to, triggering_event, *event_args|
  #   #   logger.info "#{from} -> #{to}"
  #   #   if self.intervention? && to == :dummy_state && from == :awaiting_answer_for_intervention
  #   #     logger.info "#{self.intervention? && to == :dummy_state}"
  #   #     self.update_columns(workflow_state: :awaiting_answer_for_intervention)
  #   #     logger.info "#{self.workflow_state}"
  #   #   else
  #   #     self.update_columns(workflow_state: :complete)
  #   #   end 
  #   # end
  # end

  def update_workflow_state
    case current_state
      when :new
        self.workflow_state = :awaiting_answer_for_appropriate
      when :awaiting_answer_for_appropriate
        self.workflow_state = :awaiting_answer_for_intervention
      when :awaiting_answer_for_intervention
        self.workflow_state = (self.intervention? ? :awaiting_answer_for_what_was_intervention : :complete)
      when :awaiting_answer_for_what_was_intervention
        self.workflow_state = :awaiting_answer_for_outcome
      when :awaiting_answer_for_outcome
        self.workflow_state = :complete
    end
      
    self.save
  end

  def incomplete?
    !complete?
  end

  def complete?
    self.workflow_state.complete?
  end

  def new?
     self.workflow_state.new?
  end

  def begin!
    self.workflow_state = :new
    self.save
  end

  def current_state
    self.workflow_state.to_sym
  end

  def question
    case current_state
    when :awaiting_answer_for_appropriate
      :appropriate
    when :awaiting_answer_for_intervention
      :intervention
    when :awaiting_answer_for_what_was_intervention
      :what_was_intervention
    when :awaiting_answer_for_outcome
      :outcome
    when :complete
      :complete
    end
  end

  def recommendation_likely?
    self.recommendation_likelihood.present? && self.recommendation_likelihood >= 4
  end

  def followup?
    !self.initial
  end

  def record_answer(answer)
    case current_state
    when :awaiting_answer_for_appropriate
      self.appropriate = parse_bool(answer)
    when :awaiting_answer_for_intervention
      self.intervention = parse_bool(answer)
    when :awaiting_answer_for_what_was_intervention
      self.what_was_intervention = answer
    when :awaiting_answer_for_rating
      self.rating = strip_nondigits(answer)
    when :awaiting_answer_for_outcome
      self.outcome = answer
    when :awaiting_answer_for_what_was_intervention
      self.what_was_intervention = answer
    when :awaiting_answer_for_recommendation_likelihood
      self.recommendation_likelihood = strip_nondigits(answer)
    end

    self.save && update_workflow_state
  end

  def self.send_feedback_email(no_days=10)
    last_days(no_days).each do |survey|
      InquiryResponseMailer.feedback_after_first_response(survey.responder).deliver_now
      survey.update_attribute(:sent_feedback_at, Time.now)
    end
  end

  private

  def parse_bool(maybe_string)
    if maybe_string.is_a? String
      maybe_string.downcase.strip == 'yes'
    else
      maybe_string
    end
  end

  def strip_nondigits(string)
    string.gsub(/\D/, '')
  end
end
