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

node(:custom_response_text) { @inquiry.old_response_format }

node(:received_at) { @inquiry.received_at.to_i }
node(:created_at) { @inquiry.created_at.to_i }
node(:updated_at) { @inquiry.updated_at.to_i }

node(:summary_tables) do
  @inquiry.summary_tables.map do |st|
    st = st.decorate
    {
      id: st.id,
      body_html: st.body_html,
      references: st.references
    }
  end
end
