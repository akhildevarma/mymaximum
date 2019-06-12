object @inquiry

attributes :id, :question, :status, :turnaround_time, :intervention_response,
           :custom_response_text, :background, :relevant_prescribing_info, 
           :researchable_question, :background_references, 
           :relevant_prescribing_info_references

node(:received_at) { |inquiry| inquiry.received_at.to_i }
node(:created_at) { |inquiry| inquiry.created_at.to_i }
node(:updated_at) { |inquiry| inquiry.updated_at.to_i }

node(:summary_tables) do |inquiry|
  inquiry.summary_tables.map do |st|
    st = st.decorate
    {
      id: st.id,
      body_html: st.body_html,
      references: st.references
    }
  end
end
