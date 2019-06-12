collection @inquiries, object_root: false

node(:id) { |inquiry| inquiry.id }
node(:submitter_id) { |inquiry| inquiry.submitter_id }
node(:assignee_id) { |inquiry| inquiry.assignee_id }

node(:question) { |inquiry| inquiry.question }
node(:status) do |inquiry| 
  inquiry.status == 'research' ? 'literature_search' : inquiry.status
end
node(:turnaround_time) { |inquiry| inquiry.turnaround_time }
node(:intervention_response) { |inquiry| inquiry.intervention_response }

node(:custom_response_text) { |inquiry| inquiry.old_response_format }

node(:received_at) { |inquiry| inquiry.received_at.to_i }
node(:created_at) { |inquiry| inquiry.created_at.to_i }
node(:updated_at) { |inquiry| inquiry.updated_at.to_i }
