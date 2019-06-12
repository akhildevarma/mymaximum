class InquiryDecorator < Draper::Decorator
  decorates_association :submitter, with: UserDecorator
  decorates_association :assignee, with: UserDecorator
  decorates_association :summary_tables
  delegate_all

  html_editor_fields = [ 
    :relevant_prescribing_info,
    :review_of_other_tertiary_literature,
    :search_strategy,
    :custom_response_text,
    :review_of_clinical_guidelines,
    :review_of_meta_analyses,
    :review_of_review_articles,
    :background_references,
    :relevant_prescribing_info_references,
    :background,
    :level_of_evidence
  ]



  def progress_bar_unit_width
    100.0 / Inquiry.statuses.size
  end

  def progress
    progress_bar_unit_width * model.passed_statuses.length
  end

  def assigned_to_me?
    model.assignee_id == h.current_user.id
  end


  def assignee_name
    if assigned?
      assignee.full_name_or_email
    else
      I18n.t('inquiries.no_assignee')
    end
  end

  html_editor_fields.each do |method|
    define_method method do
      if model.send(method).present?
         model.send(method).gsub('<table', "<table class='table table-striped table-bordered' ").gsub("< ", '&lt;').html_safe
      end
    end
  end

  def status_options
    Inquiry.status.options(except: :complete)
  end

end

class InquiriesDecorator < Draper::CollectionDecorator
  delegate :current_page, :per_page, :offset, :total_entries, :total_pages
end
