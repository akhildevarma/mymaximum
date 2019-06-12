require 'rails_helper'

describe 'my_profile' do
  before(:all) do
    ActionController::Base.allow_forgery_protection = true
  end
  after(:all) do
    ActionController::Base.allow_forgery_protection = false
  end

  context 'with an authenticated provider' do # other users are fine
    let!(:me) { login_as_provider }
    let(:json) {  JSON.parse(response.body) }
    describe 'GET /my_profile.json' do
      before do
        get '/my_profile.json', {}, @env
      end
      it 'responds 200' do
        expect(response.code).to eq('200')
      end
      it 'returns JSON validated by schema' do
        expect(response.body).to match_response_schema('my_profile', :legacy)
      end
      it "returns the current user's profile" do
        expect(json).to have_key('profile')
        expect(json).to have_key('user')
        expect(json).to have_key('provider')
      end
      describe 'admin user' do
        let(:admin) { create( :admin_user, :provider ) }
        let(:me) { login(admin) }
        it 'includes provider block' do
          expect(json).to have_key('provider')
        end
        it 'has `is_admin` attribute' do
          expect(json).to have_key('is_admin')
          expect(json['is_admin']).to be true
        end
      end
    end

    describe 'PATCH /my_profile.json' do
      context 'with valid input' do
        let(:user_profile) do {
          profile: {
            first_name: 'Sassy',
            last_name: 'Molassy' }
        }
        end
        it 'responds 204' do
          patch '/my_profile.json', { user_profile: user_profile }, @env
          expect(response.code).to eq('204')
        end
        it "updates the current user's profile" do
          expect do
            patch '/my_profile.json', { user_profile: user_profile }, @env
          end.to change { me.profile.reload.last_name }.to('Molassy')
        end
      end

      context 'with invalid input' do
        before { login_as_provider }
        let(:user_profile) do {
          profile: { phone_number: '1234567891011'  }
        }
        end

        it 'responds 422 UNPROCESSABLE ENTITY' do
          patch '/my_profile.json', { user_profile: user_profile }, @env
          expect(response.code).to eq('422')
        end
        it ' contains a hash of errors' do
          patch '/my_profile.json', { user_profile: user_profile }, @env
          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to eq(
            'user_profile'=> {},
            'profile' => {
              'phone_number' => ['wrong_length']
            },
            'provider' => {},
            'user' => {}
          )
        end
        context 'non-unique profile info' do
          phone_number = '770-123-9877'
          email = 'unoriginal@email.com'
          license_number = '012345'
          before do
            unoriginal_user = FactoryGirl.create(:provider_user,
                                                 email: email,
                                                 profile: FactoryGirl.build(:profile, phone_number: phone_number),
                                                 provider: Provider.new(
                                                   license_number: license_number,
                                                   licensing_state: 'GA',
                                                   specialty: 'Nurse'
                                                 )
                                                )
          end
          let(:user_profile) do
            {
              user: { email: email },
              profile: { phone_number: phone_number },
              provider: { license_number: license_number }
            }
          end
          it 'responds 422 UNPROCESSABLE ENTITY' do
            patch '/my_profile.json', { user_profile: user_profile }, @env
            expect(response.code).to eq('422')
          end
          it ' contains a hash of errors' do
            patch '/my_profile.json', { user_profile: user_profile }, @env
            parsed_body = JSON.parse(response.body)
            expect(parsed_body).to eq(
              'user_profile'=> {},
              'profile' => {
                'phone_number' => ['taken']
              },
              'provider' => {
                'license_number' => ['taken']
              },
              'user'=> {}
            )
          end
        end
      end
    end
  end

  context 'only profile information in request' do
      phone_number = '770-123-9877'
      email = 'unoriginal@email.com'
      license_number = '012345'
      before do
        unoriginal_user = FactoryGirl.create(:provider_user,
                                             email: email,
                                             profile: FactoryGirl.build(:profile, phone_number: phone_number),
                                             provider: Provider.new(
                                               license_number: license_number,
                                               licensing_state: 'GA',
                                               specialty: 'Nurse'
                                             )
                                            )
      end
      let(:user_profile) do
        {
          'profile'=>{
            'company'=>'',
            'first_name'=>'Dean',
            'last_name'=>'Kean',
            'middle_name'=>'',
            'name_suffix'=>'Jr.',
            'name_title'=>'Mr',
            'phone_number'=> phone_number # of unoriginal_user
          }
        }
      end
      context 'with a student user' do
        let!(:me) { login_as_student }
        before do
          patch '/my_profile.json', { user_profile: user_profile }, @env
        end
        it 'responds 422 UNPROCESSABLE ENTITY' do
          expect(response.code).to eq('422')
        end
        it ' contains a hash of errors' do
          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to eq(
            'user_profile'=> {},
            'profile' => {
              'phone_number' => ['taken']
            },
            'provider' => {},
            'user' => {}
          )
        end
      end
      context 'with a patient user' do
        let!(:me) { login_as_patient }
        before do
          patch '/my_profile.json', { user_profile: user_profile }, @env
        end
        it 'responds 422 UNPROCESSABLE ENTITY' do
          expect(response.code).to eq('422')
        end
        it ' contains a hash of errors' do
          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to eq(
            'user_profile'=> {},
            'profile' => {
              'phone_number' => ['taken']
            },
            'provider' => {},
            'user'=> {}
          )
        end
      end
    end
end
