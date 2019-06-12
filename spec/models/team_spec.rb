require 'rails_helper'

describe Team do
  let!(:team) { create(:team, kind: 'hospital') }
  let(:attributes) { [:name, :admin_email, :signup_url_path, :email_domain] }
  let(:attributes_hash) { Hash[attributes.map{|sym| [sym, team.send(sym)]}] }
  subject { team }
  it { is_expected.to be_persisted }
  it { is_expected.to have_attributes(attributes_hash) }
  it { is_expected.to be_valid }

  context 'invalid' do
    let(:duplicate) { create :team }
    let!(:team) { build :team,
      name: duplicate.name, # not unique
      admin_email: 'not.an.email@_but_almost', # not formatted
      email_domain: duplicate.email_domain, # not unique
      signup_url_path: duplicate.signup_url_path # not unique
    }
    subject { team }
    it { is_expected.to_not be_valid }
    it 'has errors' do
      is_expected.to have(1).errors_on(:name)
      is_expected.to have(1).errors_on(:admin_email)
      is_expected.to have(0).errors_on(:email_domain)
      is_expected.to have(1).errors_on(:signup_url_path)
    end
  end

  describe '#signup_flow_active?' do
    subject { team.signup_flow_active? }
    it 'checks all settings are present' do
      attributes.each do |attribute|
        allow_any_instance_of(Team).to receive(attribute).and_return(true)
        team.signup_flow_active?
        expect(team).to have_received attribute
      end
    end
    it { is_expected.to eq true }
    context 'missing settings' do
      before do
        team.email_domain = nil
        team.save validate: false
      end
      it { is_expected.to eq false }
    end
  end

  describe 'validates signup_url_path format' do
    it 'is invalid unless all lowercase' do
      team = create(:team, kind: 'hospital')
      team.signup_url_path = "test-Invalid"
      expect(team).not_to be_valid
    end
  end
end
