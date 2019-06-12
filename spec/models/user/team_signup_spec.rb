require 'rails_helper'

describe User::TeamSignup do
  let(:factory_instance) { build :user_team_signup }

  # Instance
  subject { factory_instance }
  it { is_expected.to be_valid }

  # Instance Methods
  its(:email) { is_expected.to eq "#{factory_instance.email_username}@#{factory_instance.team.email_domain}"}
  its(:email?) { is_expected.to eq !!subject.email}
  its(:email_domain) { is_expected.to eq "#{factory_instance.team.email_domain}" }

end
