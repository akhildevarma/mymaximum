class UploadJob < Struct.new(:team_id)
  def perform
    UploadUser.to_be_processed(team_id).each do |bulk_user|
      bulk_user.with_transaction_returning_status do
        UploadJobHelper::process_data(bulk_user)
        bulk_user.save!
      end
    end
  end
end
