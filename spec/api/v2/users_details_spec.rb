require 'rails_helper'

describe 'Users API' do
  let(:make_request) { get endpoint, {}, @env }
  
  describe 'GET /api/v2/user' do
    let(:endpoint) { "/api/v2/user" }
    
    before { 
      @me = login_as_provider_with_token
      make_request 
    }

    it_should_behave_like 'json_api'

    it do
      expect( json['data']['attributes']['email'] ).to eq @me.email
      expect( json['data']['attributes']['is-admin'] ).to eq false
      expect( json['data']['attributes']['is-active'] ).to eq true
    end
  end

  describe 'DELETE /api/v2/user' do
    let(:endpoint) { "/api/v2/user" }
    
    before { 
      @me = login_as_provider_with_token
      delete endpoint, {}, @env 
    }

    it do
      expect(response.body).to eq({
        code: 'deactivated',
        message: "Deactivated Succesfully"
      }.to_json)
      expect(User.first.is_active).to eq false
    end
  end

  describe 'Update /api/v2/user' do
    let(:endpoint) { "/api/v2/user" }
    let(:email) { 'test@test.com'}
    before { 
      @me = login_as_provider_with_token
      put endpoint, {email: email }, @env 
    }
    it_should_behave_like 'json_api'
    
    it do
      expect( json['data']['attributes']['email'] ).to eq email
    end

    describe 'with invalid email format' do
      let(:email) { 'test.usergmail.com' }
      it { expect(response).to have_http_status 400 }
      it { expect(response.body).to include('errors') }
    end

    describe 'with existing email' do
      let(:email) { @me.email }
      it { expect(response).to have_http_status 400 }
      it { expect(response.body).to include('errors') }
    end 
  end

  describe 'Add other email address' do
    let(:endpoint) { '/api/v2/user/add_other_email' }
    let(:email) { 'test@test.com'}

    before { 
      @me = login_as_provider_with_token
      put endpoint, { email: email }, @env 
    }
    it_should_behave_like 'json_api'
    it do
      expect(User::Email.last.email).to eq email
    end

    describe 'with invalid email format' do
      let(:email) { 'test.usergmail.com' }
      it { expect(response).to have_http_status 400 }
      it { expect(response.body).to include('errors') }
    end

    describe 'with existing email' do
      let(:email) { @me.email }
      it { expect(response).to have_http_status 400 }
      it { expect(response.body).to include('errors') }
    end 
  end

  describe 'Remove other email address' do
    let(:endpoint) { '/api/v2/user/remove_other_email' }
    let(:me) { login_as_provider_with_token }
    let(:email) { 'test@test.com' }
    let!(:other_email) { User::Email.create(email: email, user_id: me.id) }
    before { 
      delete endpoint, { email: email }, @env 
    }
    it_should_behave_like 'json_api'
    
    it do
      expect(User::Email.last).to be nil
    end

    context 'with invalid email format' do
      let(:email) { 'test.usergmail.com' }
      it { expect(response).to have_http_status 400 }
      it { expect(response.body).to include('errors') }
    end

    context 'with non existing other email' do
      let(:email) { 'test.user@gmail.com' }
      let!(:other_email) { User::Email.create(email: '123test@test.com', user_id: me.id) }
      it { expect(response).to have_http_status 404 }
      it { expect(response.body).to include('errors') }
    end
  end

  describe 'Set primary email address' do
    let(:endpoint) { '/api/v2/user/set_primary_email' }
    let(:me) { login_as_provider_with_token }
    let(:email) { 'test@test.com' }
    let(:is_primary) { true }
    let!(:other_email) { User::Email.create(email: email, user_id: me.id) }
    before { 
      put endpoint, { email: email, is_primary: is_primary }, @env 
    }
    it_should_behave_like 'json_api'
    
    it do
      expect(User::Email.last.is_primary).to be true
    end

    context 'with invalid email format' do
      let(:email) { 'test.usergmail.com' }
      it { expect(response).to have_http_status 400 }
      it { expect(response.body).to include('errors') }
    end

    context 'is_primary is false' do
      let(:email) { 'test.user@gmail.com' }
      let(:is_primary) { false }
      it do
        expect(User::Email.last.is_primary).to be false
      end
    end
  end
end
