RSpec.shared_examples 'page_with_javascript' do |parameter|
  it 'should not have JavaScript errors', :js => true do
    expect(page).not_to have_errors
  end
end
