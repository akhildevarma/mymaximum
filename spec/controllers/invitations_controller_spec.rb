require 'rails_helper'

describe InvitationsController do
  context 'with an admin user' do
    before :each do
      login_as_admin
    end

    describe 'POST#create' do
      it 'sends an invitation email' do
        expect do
          post :create, invitation: { email: 'foo@bar.biz', invitation_type: 'general' }
        end.to change { ActionMailer::Base.deliveries.count }.by(2)
      end

      context 'with a student invitation' do
        before do
          post :create, invitation: { email: 'foo@bar.biz', invitation_type: 'student' }
        end

        it 'contains a link to the student signup page' do
          expect(ActionMailer::Base.deliveries.last.encoded).to include(new_student_signup_url)
        end
      end

      context 'with a general invitation' do
        before do
          post :create, invitation: { email: 'foo@bar.biz', invitation_type: 'general' }
        end

        it 'contains a link to the general signup page' do
          expect(ActionMailer::Base.deliveries.last.encoded).to include(signup_url)
        end
      end
    end
  end
end
