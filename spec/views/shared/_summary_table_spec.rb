require 'rails_helper'

describe 'shared/_summary_table.html.erb' do
  let(:user) { FactoryGirl.build_stubbed(:provider_user).decorate }
  let(:inquiry) { FactoryGirl.create(:inquiry_with_table, status: :complete, submitter: user) }
  let(:summary_table) { inquiry.summary_tables[0].decorate }
  before do
    render partial: 'shared/summary_table', locals: { summary_table: summary_table }
  end
  it 'formats references' do
    expected_references_html = summary_table.references.gsub("\n", "\n<br />")
    expect(rendered).to include('references')
    expect(rendered).to include(expected_references_html)
  end
end
