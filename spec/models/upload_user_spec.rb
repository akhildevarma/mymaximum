require 'rails_helper'

RSpec.describe UploadUser, type: :model do
  describe '.process_row' do
    let(:team) { create :team }
    let(:user) { create :user }
    let(:email) { Faker::Internet.email }
    let(:first_name) { Forgery(:name).first_name }
    let(:last_name) { Forgery(:name).last_name }
    let(:phone_number) { '1112224444' }
    context 'for new user' do
      let(:batch) { create_batch(email, team.id, first_name, last_name, phone_number) }
      it 'process row and does create user, profile and provider' do
        UploadUser.process_row(batch,team.id)
        expect(UploadUser.last.status).to eq(UploadUser::COMPLETED)
        expect(UploadUser.last.message).to eq(nil)
        expect(User.last.email).to eq(UploadUser.last.email)
        expect(Profile.last.first_name).to eq(first_name)
        expect(Profile.last.last_name).to eq(last_name)
        expect(Profile.last.phone_number).to eq(phone_number)
        expect(Provider.last.specialty).to eq(UploadUser.last.specialty)
      end
    end

    context 'can have a list of processing users' do
      let(:upload_user) { create :upload_user,team_id: team.id}
      it 'list of to be processed users' do
        upload_user.save
        expect(UploadUser.to_be_processed(team.id)[0]).to eq(UploadUser.last)
      end
    end

    context 'for existing user' do
      let(:batch) { create_batch(user.email, team.id, first_name, last_name, phone_number) }
      it 'process row and does not create user/profile/provider' do
        UploadUser.process_row(batch,team.id)
        expect(UploadUser.last.status).to eq(UploadUser::ERROR)
        expect(UploadUser.last.message).to eq("Email taken")
        expect(User.last).to eq(user)
        expect(Provider.last).to eq(nil)
        expect(UploadUser.failed_users(team.id)[0]).to eq(UploadUser.last)
      end
    end

    context 'for invalid phone number for profile' do
      let(:phone_number) { '123' }
      let(:batch) { create_batch(email, team.id, first_name, last_name, phone_number) }
      it 'process row and does not create user/profile/provider' do
        UploadUser.process_row(batch,team.id)
        expect(UploadUser.last.status).to eq(UploadUser::ERROR)
        expect(UploadUser.last.message).to eq("Phone number wrong length")
        expect(User.last).to eq(nil)
        expect(Provider.last).to eq(nil)
        expect(UploadUser.failed_users(team.id)[0]).to eq(UploadUser.last)
      end
    end

    context 'for blank first/last_name for profile' do
      let(:first_name) { '' }
      let(:last_name) { '' }
      let(:batch) { create_batch(email, team.id, first_name, last_name, phone_number) }
      it 'process row and does not create user/profile/provider' do
        UploadUser.process_row(batch,team.id)
        expect(UploadUser.last.status).to eq(UploadUser::ERROR)
        expect(UploadUser.last.message).to eq("First name can't be blank,Last name can't be blank")
        expect(User.last).to eq(nil)
        expect(Provider.last).to eq(nil)
        expect(UploadUser.failed_users(team.id)[0]).to eq(UploadUser.last)
      end
    end
  end

  def create_batch(email, team_id, first_name, last_name, phone_number)
    [[ email, first_name, last_name, phone_number, 'OBGYN', team_id]]
  end
end
