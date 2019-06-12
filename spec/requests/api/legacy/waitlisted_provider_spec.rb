require 'rails_helper'

describe 'POST /waitlisted_provider.json' do
  def do_request(email = 'example@me.com')
    post '/waitlisted_provider.json',       'waitlisted_user' => {
        "email": email
      }
  end

  context 'valid email' do
    it 'returns 200' do
      do_request
      expect(response).to have_http_status(200)
    end
  end

  context 'invalid email' do
    it 'returns 400' do
      do_request('invalid_email')
      expect(response).to have_http_status(400)
    end
  end
end
