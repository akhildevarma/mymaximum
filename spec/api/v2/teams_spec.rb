require 'rails_helper'

def nested_hash_key(obj,key)
  if obj.respond_to?(:key?) && obj.key?(key)
    true
  elsif obj.respond_to?(:each)
    r = nil
    obj.find{ |*a| r=nested_hash_key(a.last,key) }
    r
  end
end

describe 'Teams API' do
  let!(:team) { create :team }
  let(:make_request) { get endpoint, {}, @env }
  let(:json) { JSON.parse response.body }

  describe 'GET /api/v2/teams' do
    let(:endpoint) { "/api/v2/teams" }
    before { Team.delete_all }
    describe 'search should only return teams with working signup' do
      let!(:team_one) { Team.new(name: 'team_one').save(validate: false) }
      let!(:team_two) { create :team, name: 'team_two'}
      let(:endpoint) { "/api/v2/teams?search=team" }
      before { make_request }
      it_should_behave_like 'json_api'
      it do
        expect( json['data'].size ).to eq 1
        expect( json['data'].first['attributes']['name'] ).to eq team_two.name
        expect( json['data'].first['attributes']['signup-url-path'] ).to eq team_two.signup_url_path
        expect( json['data'].first['attributes']['email-domain'] ).to eq team_two.email_domain
      end

    end

  end

  describe 'GET /api/v2/:team_name/users/validate' do
    let(:endpoint) { "/api/v2/#{team.signup_url_path}/users/validate" }
    let(:email) { "test.user@#{team.email_domain}" }
    let(:user) { create :user, email: email}
    before do
      get endpoint, { email: email }, @env
    end
    it { expect(response).to have_http_status 200 }
    it do
      expect(response.body).to eq({
        code: 'email_valid',
        message: "Email valid"
      }.to_json)
    end
    describe 'errors' do
      describe 'email' do
        describe 'improper domain' do
          let(:email) { "test.user@wrong-domain.com" }
          let(:wrong_domain) { 'wrong-domain.com' }
          it do
            expect(response.body).to eq({
              code: 'invalid_team_email_domain',
              message: "Invalid team email domain: #{ wrong_domain }. Email domain must match team domain: #{ team.email_domain }."
            }.to_json)
          end
        end
        describe 'invalid email' do
          let(:email) { "^@(*$&@#{team.email_domain}" }
          it do
            expect(response.body).to eq({
              code: 'email_invalid',
              message: "#{ email } doesn't appear to be a valid email."
            }.to_json)
          end
        end
        describe 'user exists' do
          let(:email) { "test.user@#{team.email_domain}" }
          it do
            create :user, email: email
            get endpoint, { email: email }, @env
            expect(response.body).to eq({
              code: 'user_exists',
              message: "User with email #{ email } already exists. Please login or reset password."
            }.to_json)
          end
        end
      end
    end
  end

  describe 'POST /api/v2/:team_name/users' do
    let(:endpoint) { "/api/v2/#{team.signup_url_path}/users" }
    let(:email) { "test.user@#{team.email_domain}" }
    let(:password) { 'password' }
    let(:password_confirmation) { 'password' }
    let(:signup) { build :user, email: email, password: password, password_confirmation: password_confirmation }
    let(:params) do
      {
        user: signup.slice(:email, :password, :password_confirmation)
      }
    end
    before do
      post endpoint, params, @env
    end
    it { expect(response).to have_http_status 201 }
    it { expect( User.first.email ).to eq email }

    describe 'with non-team email' do
      let(:email) { 'test.user@gmail.com' }
      it { expect(response).to have_http_status 400 }
    end

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

  end

  def does_error
    it { is_expected.to have_http_status 404 }
    its(:body) { is_expected.to include('errors') }
  end

end
