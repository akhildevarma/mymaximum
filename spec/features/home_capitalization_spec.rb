require 'feature_helper'
include SessionHelper

feature 'home page'  do
  before do
    visit root_path
  end

  scenario 'Capitalization of Headers' do
  	
 expect(page).not_to  have_content('Turnaround Time')
 expect(page).not_to  have_content('Pharmacy and Therapeutics (P&T) Request')
end
end