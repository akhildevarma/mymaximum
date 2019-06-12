require 'feature_helper'

feature 'Inquiry response tabbed navigation', :js, :ignore_js_errors do
  let!(:user_one) { create :provider_user }
  let(:inquiry) { create :published_inquiry, submitter: user_one }

  context 'with user' do
    background do
      login user_one
      visit_inquiry_page
    end

    context 'default tab selected' do
      scenario do
        # although all sections are available
        # view only first section on page
        test_default_tab('All')
      end
    end

    context 'select background tab' do
      background do
        select_tab 'Background'
        # view all sections on one visible page
        # preference for all is remembered (new default)
      end
      scenario 'Background is now default' do
        visit_inquiry_page
        test_default_tab('Background')
      end
    end
  end

  def visit_inquiry_page
    visit "/inquiries/#{inquiry.id}"
  end

  def test_default_tab(text)
    within('#inquiry-response-tabs') do
      expect(first('.md-tab.md-active .in-tab-item').text).to have_content /#{text}/i
    end
  end

  def select_tab(text)
    within('#inquiry-response-tabs') do
      first('md-tab-item', text: text).click
    end
  end


end
