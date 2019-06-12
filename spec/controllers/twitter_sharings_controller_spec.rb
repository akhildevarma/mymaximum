require 'rails_helper'

describe TwitterSharingsController do
  describe 'POST#create' do
    it 'redirects to Twitter' do
      post :create, twitter_link: 'twitter_find_us_link'
      expect(response.location).to match "twitter\.com"
    end
  end
end
