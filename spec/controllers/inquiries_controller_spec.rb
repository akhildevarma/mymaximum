require 'rails_helper'

describe InquiriesController do
  describe 'GET#show' do
    let!(:user_one) { create :provider_user }
    let!(:team) { create :team }
    let!(:user_two) { create :provider_user, team: team }
    let!(:user_two_inquiry) { create :completed_inquiry, submitter: user_two }
    describe "only shows published or owned inquiries" do
      it do
        expect {
            login user_one
            get :show, id: user_two_inquiry.id
        }.to raise_error ActiveRecord::RecordNotFound
      end

      it do
        expect {
            login user_two
            get :show, id: user_two_inquiry.id
        }.not_to raise_error
      end

    end
  end

  describe 'GET#send_response' do
    let(:inquiry) { create :inquiry_with_table }
    let!(:me) { login_as_student }
    it do
      expect { get :send_response, id: inquiry.id }.to_not raise_error
    end
  end
end
