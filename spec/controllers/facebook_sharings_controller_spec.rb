require 'rails_helper'

describe FacebookSharingsController do
  describe 'POST#create' do
    it 'redirects to Facebook' do
      post :create, facebook_link: 'facebook_find_us_link'
      expect(response.location).to match "facebook\.com"
    end
  end
end
