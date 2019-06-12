require 'feature_helper'
include SessionHelper

feature 'Tags', :js, :show_browser, :ignore do
  let(:student) { login_as_student }
  let(:inquiry) { create(:inquiry, assignee: student, status: 'complete') }
  scenario 'Student edit inquiry view' do
    visit_inquiry( inquiry )
    # sleep(inspection_time=10)
    # Correct tags displayed
    inquiry.tag_list.each do |tag|
      expect(page).to have_content(tag)
    end
    # Tags correctly seperated for display
    expect(page).to have_selector('.tag', count: inquiry.tag_list.count)

  end

  let(:new_tag) { "NewTag" }
  feature 'autosave' do
    context 'when adding tag' do
      it 'works' do
        visit_inquiry( inquiry )
        tag( 'add', new_tag )
        # Should be autosaved
        tag_should_be_saved(new_tag)
      end
    end
    context 'when removing tag' do
      let(:tag_name) { inquiry.tag_list.first }
      it 'works' do
        visit_inquiry( inquiry )
        tag( 'remove', tag_name )
        expect(page).to_not have_content(tag_name)
        visit current_path
        expect(page).to_not have_content(tag_name)
      end
    end
  end

  let(:shared_tag) { inquiry.tag_list.first }
  let(:related_inquiry) { create(:inquiry, status: 'complete') }
  scenario 'Student inquiry related by tag' do
    related_inquiry.tag_list.add(shared_tag)
    related_inquiry.save!
    visit_inquiry( inquiry )
    click_on 'Browse Related'
    # Should find related inquiry
    expect(page).to_not have_content('No related inquiries found.')
    # Correct tags displayed
    expect(page).to have_content(shared_tag, count: 2)
    # Tags correctly seperated for display
    total_tag_count = inquiry.tag_list.count + related_inquiry.tag_list.count
    expect(page).to have_selector('.tag', count: total_tag_count)
  end

  def open_inquiry(inquiry)
    click('div.question', text: inquiry.question)
  end

  def visit_inquiry(inquiry)
    visit '/inquiries'
    click_on 'Closed Inquiries'
    open_inquiry( inquiry )
  end

  def tag(action, text)
    page.execute_script("""
      $('#inquiry_tag_list').tagsinput('#{action}', '#{text}');
    """)
  end

  def tag_should_be_saved(tag_name)
    # Visibly entered on page
    expect(page).to have_content(tag_name)
    # Visible on page after reload
    visit current_path
    expect(page).to have_content(tag_name)
    # Saved in database
    # expect( Inquiry.find(inquiry.id).tag_list ).to include new_tag_text
  end

  def click(selector, options={})
    if options.has_key?(:text)
      selector = "\"#{selector}:contains('#{options[:text]}')\""
    end
    if Capybara.current_driver == :selenium
      page.execute_script """
        $(#{selector}).trigger('click')
      """
    else
      page.find(selector, options).trigger('click')
    end
  end
end
