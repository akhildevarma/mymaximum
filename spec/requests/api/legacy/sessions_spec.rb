require 'rails_helper'

describe 'sessions' do
  describe 'POST /sessions.json' do
    context 'with a valid email / password combination' do
      let(:user) { FactoryGirl.create(:user) }
      before do
        post '/session.json', email: user.email, password: user.password
      end
      it 'responds 200' do
        expect(response.code).to eq('200')
      end
      it 'returns JSON validated by schema' do
        expect(response.body).to match_response_schema('session', :legacy)
      end
    end

    context 'with an invalid email / password combination' do
      let(:email) { 'phony@baloney.biz' }
      let(:password) { 'letmein' }
      it 'responds 401' do
        post '/session.json', email: email, password: password
        expect(response.code).to eq('401')
      end
    end
  end
end
