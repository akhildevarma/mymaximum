class MyInquirySerializer < ActiveModel::Serializer
  attributes :id, :submitter_id, :assignee_id, :created_at, :turnaround_time, :status, :question, :errors

  def created_at
    object.created_at.to_i
  end

  def received_at
    object.received_at.to_i
  end
end
