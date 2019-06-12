require 'feature_helper'
include SessionHelper

feature 'Viewing and copying related inquiries' do
  context 'as a student' do
    let!(:me) { login_as_student }

    let!(:inquiry) { FactoryGirl.create(:inquiry) }
    let!(:related_inquiry) { FactoryGirl.create(:inquiry_with_table, tag_list: inquiry.tag_list).decorate }

    let!(:background_inquiry) { FactoryGirl.create(:inquiry_with_table, tag_list: inquiry.tag_list, background: 'background').decorate }
    let!(:inquiry_with_review) { FactoryGirl.create(:inquiry_with_reviews, tag_list: inquiry.tag_list).decorate }
    scenario 'I can view inquiries related to a given inquiry' do
      visit edit_inquiry_path(inquiry)
      click_on 'Browse related'
      within('#inquiries') do
        expect(page).to have_content(related_inquiry.question)
      end
    end

    scenario 'I can copy the response from a related inquiry' do
      visit inquiry_related_inquiry_path(inquiry, related_inquiry)
      click_on 'Copy Response'

      expect(page).to have_content('Response copied successfully')
      expect(page).to have_content('Table 1')
    end

    scenario 'copies source inquiry reviews  into dest. inquiry review sections ' do
      visit inquiry_related_inquiry_path(inquiry, inquiry_with_review)
      click_on 'Copy Response'

      inquiry.reload
      expect(inquiry.review_of_clinical_guidelines).to eq(inquiry_with_review.review_of_clinical_guidelines)
      expect(inquiry.review_of_meta_analyses).to eq(inquiry_with_review.review_of_meta_analyses)
      expect(inquiry.review_of_review_articles).to eq(inquiry_with_review.review_of_review_articles)
      expect(inquiry.review_of_other_tertiary_literature).to eq(inquiry_with_review.review_of_other_tertiary_literature)
    end
  end
end
