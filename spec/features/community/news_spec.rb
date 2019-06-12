require 'feature_helper'

feature "News", :ignore do
  let!(:news) { create_list :published_inquiry, 5 }
  background { visit "/news" }
  it { has_publically_available_inquiries }
  context 'on landing page' do
    background { visit '/' }
    it { has_publically_available_inquiries }
  end

  def has_publically_available_inquiries
    news.each do |item|
      expect(page).to have_content item.question
      expect { click_on item.question }.to change { current_url }
      visit page.driver.request.env['HTTP_REFERER']
    end
  end
end
