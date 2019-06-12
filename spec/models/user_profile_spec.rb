require 'rails_helper'

describe UserProfile do
  let!(:user) { FactoryGirl.create(:student_user) }
  let!(:user_profile) { UserProfile.for(user) }
  subject { user_profile }

  it { is_expected.to be_kind_of JsonErrorResource }

  describe '#json_errors' do
    its(:json_errors) { is_expected.to_not be_empty }
  end
end
