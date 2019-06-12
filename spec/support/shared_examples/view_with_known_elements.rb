RSpec.shared_examples "view_with_known_elements" do |parameter|
  let(:page) { Capybara::Node::Simple.new( rendered ) }
  before { render }
  subject { page }
  it do
    if defined? text_elements
      for text in text_elements
        expect(page).to have_content(text)
      end
    end
  end
  it do
    if defined? button_elements
      for button in button_elements
        expect(page).to have_button(button)
      end
    end
  end
end
