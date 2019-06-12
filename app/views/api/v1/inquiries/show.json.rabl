object false


node(:id) { @inquiry.id }
node(:submitter_id) { @inquiry.submitter_id }
node(:assignee_id) { @inquiry.assignee_id }

node(:question) { @inquiry.question }
node(:status) do
  @inquiry.status == 'research' ? 'literature_search' : @inquiry.status
end
node(:turnaround_time) { @inquiry.turnaround_time }
node(:intervention_response) { @inquiry.intervention_response }

node(:custom_response_text) { @inquiry.custom_response_text }
node(:search_strategy) { @inquiry.search_strategy }

node(:background) do
  {
    body: @inquiry.background,
    references: @inquiry.background_references
  }
end

node(:prescribing_information) do
  {
    prescriptions: @inquiry.relevant_prescribing_info,
    references: @inquiry.relevant_prescribing_info_references
  }
end

node(:literature_review) do
  {
    summary_tables: @inquiry.summary_tables.map do |st|
        st = st.decorate
        table_hash = {}
        table_hash[:formatted] = st.body_html unless ['unformatted'].include? params[:table_format]
        table_hash[:unformatted] = st.data if ['unformatted', 'both'].include? params[:table_format]
        {
          id: st.id,
          reference: st.references,
          table: table_hash
        }
    end
  }
end

node(:received_at) { @inquiry.received_at.to_i }
node(:created_at) { @inquiry.created_at.to_i }
node(:updated_at) { @inquiry.updated_at.to_i }
