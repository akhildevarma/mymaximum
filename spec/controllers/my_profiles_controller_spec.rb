require 'rails_helper'

include SessionHelper

describe MyProfilesController do
  describe 'PATCH#update' do
    before do
      login_as_provider
    end

    context 'with valid params' do
      let(:params) do
        {
          user_profile: {
            user: {},
            profile: {
              first_name: 'John',
              last_name: 'Mayor',
              phone_number: '4045056606'
            }
          }
        }
      end

      it 'renders HTML' do
        patch :update, params
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid params' do
      let(:params) do
        {
          user_profile: {
            user: {
              password: 'password',
              password_confirmation: 'non_matching_password'
            },
            profile: {
              first_name: 'John',
              last_name: 'Mayor',
              phone_number: '4045056606'
            }
          }
        }
      end

      it 'renders HTML' do
        patch :update, params
        expect(response).to render_template(:edit)
      end
    end
  end
end
