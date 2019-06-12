require 'rails_helper'


describe 'POST /api/v2/provider_signup', :vcr do

    before do
      ApplicationSettings.load.update!(require_general_invitations: false)
      allow(Stripe::Customer).to receive(:create) { double('Customer', id: '12345') }
    end

    let(:password) { Faker::Internet.password(8) }
    let(:password_confirmation) { password }
    let!(:user) { create :user }
    let!(:provider_user) { create :provider_user }
    let!(:profile) { create :profile, user: user }
    let(:email) { Faker::Internet.email }
    let(:first_name) { Faker::Name.first_name }
    let(:last_name) { Faker::Name.last_name }
    let(:phone_number) { Faker::Number.number(10) }
    let(:license_number) { Faker::Number.number(10) }
    let(:licensing_state) { 'GA' }
    let(:specialty) { 'test specialist' }
    let(:params) do
      {
        accept_terms_of_service: '1',
        user: {
          email: email,
          password: password,
          password_confirmation: password_confirmation
        },
        provider: {
          license_number: license_number,
          licensing_state: licensing_state,
          specialty: specialty
        },
        profile: {
          first_name: first_name,
          last_name: last_name,
          phone_number: phone_number
        }
      }
    end

    let(:endpoint) { "/api/v2/provider_signup" }
    let(:make_request) { post endpoint, params, @env }
    let!(:status) { make_request }
    let(:json) { JSON.parse response.body }
    subject { response }

    it_should_behave_like 'json_api'
    it { is_expected.to have_http_status 201 }
    it { expect( User.last.email ).to eq params[:user][:email] }
    it { expect( Profile.last.first_name ).to eq first_name }
    it { expect( Provider.last.license_number ).to eq license_number }
    
    describe 'with invalid email format' do
      let(:email) { 'test.usergmail.com' }
      it { expect(response).to have_http_status 400 }
      it { expect(response.body).to include('errors') }
    end

    describe 'with too short password' do
      let(:password) { 'pass' }
      it { expect(response).to have_http_status 400 }
      it { expect(response.body).to include('errors') }
    end

    describe 'password does not match with password_confirmation' do
      let(:password_confirmation) { 'pass' }
      it { expect(response).to have_http_status 400 }
      it { expect(response.body).to include('errors') }
    end

    describe 'user already exist' do
      let(:email) { user.email }
      it { expect(response).to have_http_status 400 }
      it { expect(response.body).to include('errors') }
    end

    describe 'no first /last names present' do
      let(:first_name) { nil }
      let(:last_name) { nil }
      it { expect(response).to have_http_status 400 }
      it { expect(response.body).to include('errors') }
    end

    describe 'license_number and licence state exist' do
      let(:license_number) { provider_user.provider.license_number }
      let(:license_state) { provider_user.provider.license_state  }
      it { expect(response).to have_http_status 400 }
      it { expect(response.body).to include('errors') }
    end

    describe 'no phone_number' do
      let(:phone_number) { nil }
      it { expect(response).to have_http_status 201 }
      it { expect(response.body).to_not include('errors') }
    end

    describe 'no specialty' do
      let(:specialty) { nil }
      it { expect(response).to have_http_status 201 }
      it { expect(response.body).to_not include('errors') }
    end

end
