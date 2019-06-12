require 'feature_helper'
include SessionHelper

feature 'Responding to an inquiry' do
  context 'as a student' do
    let!(:me) { login_as_student }

    context 'when I am working on an inquiry' do
      let!(:inquiry) { FactoryGirl.create(:inquiry, assignee: me) }

      scenario 'I can stop working on it' do
        visit edit_inquiry_path(inquiry)
        click_on 'Stop Working'

        expect(page).to have_content('No one is working on this inquiry.')
      end
    end

context 'with an inquiry without any existing tables' do
      let!(:inquiry) { FactoryGirl.create(:inquiry, search_strategy: 'test strategy') }
      let(:table) { '<table><tr><td colspan=2>Table</td></tr><td>Label</td><td>Value</td></tr></table>' }

      scenario "I can update the inquiry's status" do
        visit '/inquiries'
        first('.inquiry > a').click

        select 'Review', from: 'Current Status'
        click_on 'Save Changes'

        expect(page).to have_content('Inquiry updated successfully.')

      end

      scenario 'I can add a table to the inquiry' do
        visit '/inquiries'
        first('.inquiry > a').click

        click_on 'Add a Table'

        fill_in 'Table', with: table
        click_on 'Add Table'

        expect(page).to have_content('Table added successfully.')
        expect(page).to have_content('Table 1')
        expect(page).to have_content(me.email)
      end
    end
 
context 'update review fields and other relevant fields' do
      let!(:inquiry) { FactoryGirl.create(:inquiry_with_table) }
      let(:review_of_clinical_guidelines) { Faker::Lorem.sentence }
      let(:review_of_meta_analyses) { Faker::Lorem.sentence }
      let(:review_of_review_articles) { Faker::Lorem.sentence }
      let(:review_of_other_tertiary_literature) { Faker::Lorem.sentence }
      
      scenario 'I can update background review fields' do
        visit '/inquiries'
       first('.inquiry > a').click
        fill_in 'Review of Clinical Guidelines', with: review_of_clinical_guidelines
        fill_in 'Review of Meta Analysis', with: review_of_meta_analyses
        fill_in 'Review of Articles', with: review_of_review_articles
        fill_in 'Review of Other Tertiary Literature', with: review_of_other_tertiary_literature
        click_on 'Save Changes'
        expect(page).to have_content('Inquiry updated successfully.')

        [ review_of_clinical_guidelines, review_of_meta_analyses, review_of_review_articles, review_of_other_tertiary_literature ].each { |background|
           expect(page).to have_content(background)
        }
      end

      scenario 'Checking User mail addresss' do
           
      visit '/inquiries'
       first('.inquiry > a').click
       expect(page).to have_content(inquiry.submitter.email) 

    end

      scenario 'Positioning and Capitalizing the button' do
         
       visit '/inquiries'
       first('.inquiry > a').click
       expect(page).to have_content('Use Researchable Question')
   
     end
scenario 'Capitalizing the headers' do
       visit '/inquiries'
       first('.inquiry > a').click
       expect(page).to have_content('Respond to an inquiry')
       expect(page).to have_content('Browse related')
       expect(page).to have_content('Assign to me')
       expect(page).to have_content('Current Status')
       expect(page).to have_content('Researchable Question')
       expect(page).to have_content('Custom Response Text')
       expect(page).to have_content('Search Strategy')
       expect(page).to have_content('Review of Clinical Guidelines')
       expect(page).to have_content('Review of Meta Analysis')
       expect(page).to have_content('Review of Articles')
       expect(page).to have_content('Review of Other Tertiary Literature')
       expect(page).to have_content('Search Strategy')
       expect(page).to have_content('References')
       expect(page).to have_content('Relevant Prescribing Info')
       expect(page).to have_content('Relevant Prescribing Info References')
     end

end

    context 'with an inquiry with an existing table' do
      let!(:inquiry) { FactoryGirl.create(:inquiry_with_table) }

      scenario 'I can edit the table' do
        visit '/inquiries'
        first('.inquiry > a').click

        click_on 'Edit'
        click_on 'Update Table'

        expect(page).to have_content('Table updated successfully.')
      end
    end

    context 'with an inquiry in Review status' do
      let!(:inquiry) { FactoryGirl.create(:inquiry_with_table, status: :review, search_strategy: 'test strategy') }

      scenario 'I can review and approve the response' do
        visit edit_inquiry_path(inquiry)
        click_on 'Review Response'
        click_on 'Approve and Send'

        expect(page).to have_content('Inquiry response sent successfully')
        expect(page).to_not have_link('Respond', href: edit_inquiry_path(inquiry))
      end

      scenario 'see search strategy hyper link' do
        visit edit_inquiry_path(inquiry)
        click_on 'Review Response'
        click_on 'Review of Literature'
        expect(page).to have_link('Search Strategy', href: '#collapseOne')
        expect(page).to have_content('test strategy')
      end
    end

    context 'with an inquiry in Review status and no search strategy' do
      let!(:inquiry) { FactoryGirl.create(:inquiry_with_table, status: :review) }

      scenario 'I can review and approve the response' do
        visit edit_inquiry_path(inquiry)
        click_on 'Review Response'
        click_on 'Approve and Send'

        expect(page).to have_content('Inquiry response sent successfully')
        expect(page).to_not have_link('Respond', href: edit_inquiry_path(inquiry))
      end

      scenario 'can not see search strategy hyper link' do
        visit edit_inquiry_path(inquiry)
        click_on 'Review Response'
        click_on 'Review of Literature'
        expect(page).to_not have_link('Read more',href: '#collapseOne')
        expect(page).to_not have_content('test strategy')
      end
    end
  end
end
