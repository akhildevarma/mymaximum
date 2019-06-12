require 'rails_helper'

describe 'shared/_response.html.erb' do
  it 'properly displays custom_response_text' do
    user = FactoryGirl.build_stubbed(:provider_user).decorate
    inquiry = FactoryGirl.build_stubbed(:inquiry_with_table, status: :complete, submitter: user,
      custom_response_text: 'test with unescaped html < text after unescaped html character'
                                       ).decorate

    render partial: 'shared/response', locals: { inquiry: inquiry }
    expect(rendered).to include('test with unescaped html')
    expect(rendered).to include('text after unescaped html character')
  end
end
