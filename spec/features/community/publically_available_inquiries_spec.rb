require 'feature_helper'

feature 'Publically available inquiries', :ignore do

  feature "can exist" do
  end

  context "on webapp" do
    scenario "have their own page" do
      visit "/news"
    end
  end
end
