require 'rails_helper'
describe UploadJob do
 let(:upload_users) { create_list :upload_user, 5 }
 let(:team) { create :team }
 let(:job) { UploadJob.new(team.id) }

  describe '#perform' do
    before do
      save_team
    end

    it 'add users profile and provider' do
      expect do
        job.perform
      end.to change { User.count }.by(upload_users.count)
      expect(Provider.count).to eq(upload_users.count)
      expect(UploadUser.last.status).to eq(UploadUser::COMPLETED)
    end

    def save_team
      team.save
      upload_users.each {|buser|
        buser.team_id = team.id
        buser.save
      }
    end
  end
end
