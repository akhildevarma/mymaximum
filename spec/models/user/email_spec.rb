require 'rails_helper'

describe User::Email do
  let!(:email) { build(:user_email).email }
  let!(:user_email) { create :user_email, email: email }
  describe 'email attribute' do
    describe 'ensures uniqueness' do
      describe 'before database' do
        it do
          expect {
            build(:user_email, email: email).save!
          }.to raise_error ActiveRecord::RecordInvalid
        end
      end
      describe 'in database' do
        it do
          expect {
            build(:user_email, email: email).save(validate: false)
          }.to raise_error ActiveRecord::RecordNotUnique
        end
      end
    end
  end
end
