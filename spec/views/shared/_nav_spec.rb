require 'rails_helper'

describe 'shared/_nav.html.erb' do
  before do
    user = FactoryGirl.build_stubbed(:provider_user).decorate
    allow(view).to receive(:authenticated?).and_return true
    allow(view).to receive(:provider?).and_return true
    allow(view).to receive(:student?).and_return true
    allow(view).to receive(:administrator?).and_return true
    allow(view).to receive(:current_layout?).and_return true
    allow(view).to receive(:current_user).and_return user
    allow(view).to receive(:feature?).and_return true
    render partial: 'shared/nav', locals: { }
  end
  it 'renders nav links' do
    expect(rendered).to include('Teams')
  end
end
