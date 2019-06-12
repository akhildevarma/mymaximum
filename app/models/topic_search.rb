class TopicSearch < ActiveRecord::Base
  belongs_to :submitter, class_name: 'User', inverse_of: :topic_searches

  validates :search_terms, presence: { if: ->(t) { t.drug_name.blank? } }
  validates :drug_name, presence: { if: ->(t) { t.search_terms.blank? } }

  scope :reverse_chronological_order, -> {
    order(created_at: :desc)
  }

  scope :submitted_by, ->(user) { where(submitter_id: user.id) }

  after_create :start_queries

  def complete?
    self.medline_plus_query_complete? && self.guideline_gov_query_complete?  && self.daily_med_query_complete? && self.fda_query_complete?
  end

  def search_terms_with_drug_name
    [search_terms, drug_name].reject(&:blank?).join(' ')
  end

  def job_statuses
    {
      complete: self.complete?,
      medline_plus_query_complete: self.medline_plus_query_complete?,
      medline_plus_result: self.medline_plus_result,
      guideline_gov_query_complete: self.guideline_gov_query_complete?,
      guideline_gov_result: self.guideline_gov_result,
      daily_med_query_complete: self.daily_med_query_complete?,
      daily_med_result: self.daily_med_result,
      fda_query_complete: self.fda_query_complete?,
      fda_result: self.fda_result
    }
  end

  def result_stats
    {
      medline_plus_result: self.medline_plus_result?,
      guideline_gov_result: self.guideline_gov_result?,
      daily_med_result: self.daily_med_result?,
      fda_result: self.fda_result?
    }
  end

  private

  def start_queries
    Delayed::Job.enqueue MedlinePlusJob.new(self.id)
    Delayed::Job.enqueue GuidelineGovJob.new(self.id)
    Delayed::Job.enqueue DailyMedJob.new(self.id)
    Delayed::Job.enqueue FdaJob.new(self.id)
  end
end
