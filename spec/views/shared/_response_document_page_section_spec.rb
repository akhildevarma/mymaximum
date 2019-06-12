require 'rails_helper'

describe 'shared/_response_document_page_section.html.erb' do
  let(:user) {
    FactoryGirl.build_stubbed(:admin_user).decorate
  }

  before do
    @background = %Q(
      After 6 days of continuing at 10 mg warfarin (if INR still not above 1.5), the following is recommended:
        Check INR on day 6:  For INR <1.5 give 7.5 - 12.5 mg
        Check INR on day 5:  For INR <1.5 give 10 mg
        Check INR on day 4:  For INR <1.5 give 10 mg
        Check INR on day 3:  For INR <1.5 give 5 - 10 mg [3]
    )
    @inquiry = FactoryGirl.create(:inquiry_with_table, status: :review, submitter: user, background: @background).decorate

    # @inquiry.stub(:assignee_name).and_return(user.full_name)
    # @inquiry.stub(:assigned_to_me?).and_return(true)
    # view.stub(:admin?).and_return(false)
    # view.stub(:feature).and_return(true)
  end

  it 'escapes html and renders multiline text', :ignore do
    render :partial => "shared/response_document_page_section.html.erb", :locals => {
      title: 'Background',
      object: @inquiry.background,
      references: @inquiry.background_references
    }
    expect(rendered).to include("After 6 days of continuing at 10 mg warfarin (if INR still not above 1.5), the following is recommended:\n<br />        Check INR on day 6:  For INR &lt;1.5 give 7.5 - 12.5 mg\n<br />        Check INR on day 5:  For INR &lt;1.5 give 10 mg\n<br />        Check INR on day 4:  For INR &lt;1.5 give 10 mg\n<br />        Check INR on day 3:  For INR &lt;1.5 give 5 - 10 mg [3]\n")
  end

end
