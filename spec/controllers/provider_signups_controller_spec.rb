require 'rails_helper'

describe ProviderSignupsController do
  describe 'GET#new' do
    context 'user[team_id] param' do
      context 'present' do
        before { get :new, user: { team_id: 1 } }
        it { expect(assigns(:user_in_team)).to be true }
      end
      context 'not present' do
        before { get :new }
        it { expect(assigns(:user_in_team)).to be false }
      end
    end
  end
  describe '#errors_for' do
    let(:controller) { ProviderSignupsController.new }
    let(:provider_signup) { build :provider_signup_with_errors }
    subject { controller.send :errors_for, provider_signup }
    it { is_expected.to be_a ErrorSerializer }
    it { is_expected.to respond_to :to_json }
  end
end
