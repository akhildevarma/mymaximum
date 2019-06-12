class UploadUser < ActiveRecord::Base
  PENDING = 'pending'
  PROCESSING = 'processing'
  COMPLETED = 'completed'
  ERROR = 'error'

  scope :to_be_processed,
    ->(team_id) { where("team_id = ? and (status is null or status='')", team_id) }

  scope :failed_users,
    ->(team_id) { where("team_id = ? and status='error'", team_id) }

  def self.process_file(parsed_file,team_id)
    batch, batch_size = [], 1000
    total_rows  = 0
    parsed_file.each_with_index do |row, i|
      if i == 0
        row << 'team_id'
        self.build_headers(row)
      else
        batch << (row << team_id)
      end
      if batch.size >= batch_size
        self.process_row(batch,team_id)
        batch = []
      end
      total_rows = i
    end
    self.process_row(batch,team_id)

    total_rows
  end

  private
    def self.process_row(batch,team_id)
      UploadUser.import self.expected_headers, batch, validate: false
      if batch.size >= 10
        Delayed::Job.enqueue UploadJob.new(team_id)
      else
        self.to_be_processed(team_id).each do |bulk_user|
          bulk_user.with_transaction_returning_status do
            UploadJobHelper::process_data(bulk_user)
            bulk_user.save!
          end
        end
      end
    end

    def self.build_headers(row)
      headers = {}
      row.each_with_index{|x,i| headers[x] = i }
      missing_headers = self.expected_headers - headers.keys
      if missing_headers.length > 0
        raise "Missing required header entry '#{missing_headers[0]}'"
      end

      headers
    end

    def self.expected_headers
      ['email','first_name','last_name','phone_number','specialty','team_id']
    end
end
