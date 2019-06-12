class HospitalDrug < ActiveRecord::Base
   
  validates :title, uniqueness: { case_sensitive: false }
  
  def self.process_file(parsed_file,team_id)
    batch, batch_size = [], 1000
    total_rows  = 0
    parsed_file.each_with_index do |row, i|
      if i == 0
        row << 'team_id'
        self.build_headers(row)
      else
        row.map!(&:downcase)
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

  def self.search(query, team_id)
    if query.present?
      HospitalDrug.where("title ILIKE :search and team_id = #{team_id}", search: "%#{query}%")
    else
      HospitalDrug.where(team_id: team_id)
    end
  end

  private
    def self.process_row(batch,team_id)
      if batch.present?
        HospitalDrug.import self.expected_headers, batch, validate: true, on_duplicate_key_update: [:title]
      end
      # if batch.size >= 100
      #   Delayed::Job.enqueue UploadJob.new(team_id)
      # else
      #   self.to_be_processed(team_id).each do |bulk_user|
      #     bulk_user.with_transaction_returning_status do
      #       UploadJobHelper::process_data(bulk_user)
      #       bulk_user.save!
      #     end
      #   end
      # end
    end

    def self.build_headers(row)
      headers = {}
      row.each_with_index{|x,i| headers[x] = i }
      missing_headers = self.expected_headers - headers.keys
      # if missing_headers.length > 0
      #   raise "Missing required header entry '#{missing_headers[0]}'"
      # end

      headers
    end

    def self.expected_headers
      ['title','team_id']
    end
end
