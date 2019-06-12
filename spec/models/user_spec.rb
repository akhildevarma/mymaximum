require 'rails_helper'

describe User do
  let(:password) { 'test1234' }
  let!(:user) { FactoryGirl.create(:patient_user, password: password, password_confirmation: password) }

  describe 'destroying a user' do
    it 'deletes her profile' do
      expect { user.destroy }
        .to change { Profile.count }
        .by(-1)
    end

    it 'deletes her role' do
      expect { user.destroy }
        .to change { Patient.count }
        .by(-1)
    end

    it 'deletes her payment_account' do
      expect { user.destroy }
        .to change { PaymentAccount.count }
        .by(-1)
    end
  end

  describe '.for_authentication' do
    let!(:user_record) { create :user }
    let!(:user_email_record) { create :user_email, user: user_record }
    let(:user_emails) { [ user_record.email, user_email_record.email ] }
    it 'returns user by email' do
      user_email_record.activate_email!
      user_emails.each do |email|
        user = User.for_authentication(email: email)
        expect(user).to eq user_record
      end
    end
    it 'can have deprecation_warning' do
      deprecated = create :user_email, is_deprecated: true, user: user_record
      deprecated.activate_email!
      user, deprecation_warning = User.for_authentication(email: deprecated.email, set_deprecation_warning: true)
      expect(user).to eq user_record
      expect(deprecation_warning).to be true
    end
  end

  describe '.authenticate' do
    it 'updates last_active_at' do
      last_active_at = DateTime.now - 10.days
      email = user.email
      user.update_attribute(:last_active_at, last_active_at)
      # authenticate user
      User.authenticate(email, password)
      # get updated user instance
      user = User.find_by_email(email)
      expect(user.last_active_at > last_active_at).to be true
    end
  end

  describe '.to_csv',:ignore do
    let!(:profile) { create :profile, user: user}
    it 'uses specified header_names' do
      header_names = [
        :id,
        :email,
        :password_digest,
        :created_at,
        :team_id,
        :first_name,
        :middle_name,
        :last_name,
        :name_suffix,
        :name_title,
        :company,
        :city,
        :state,
        :phone_number
      ].join(',')
      output_csv = User.to_csv
      expect(output_csv).to include header_names
    end
  end

  describe '#type' do
    it 'works' do
      types = [:patient, :provider, :student]
      types.each do |type|
        user = create "#{type}_user".to_sym
        expect(user.type).to include(type.to_s)
      end
    end
  end

  describe '#by_inquiries_count' do
    before do
      create_list(:provider_user, 10) do |user|
          create_list :inquiry, 10, submitter_id: user.id
      end
    end
    it { expect(User.by_inquiries_count[0].inquiries_count).to eq 10 }
  end
  describe '#active_last_30' do
    it 'works' do
      User.active_last_30
    end
  end
  describe '#active_last_week' do
    it 'works' do
      User.active_last_week
    end
  end
  describe '#registered_last_week' do
    it 'works' do
      User.registered_last_week
    end
  end
  describe '#active!' do
    let(:user) { create :provider_user }
    it 'works' do
      expect(user.last_active_at).to be_nil
      user.active!
      expect(user.last_active_at).to_not be_nil
      time = user.last_active_at
      expect(time.utc?).to be true
    end
  end

  describe '#trialing?' do
    let(:user) { create :provider_user }
    it 'returns true if user in trial' do
      expect(user.payment_account.trialing?).to be true
      expect(user.trialing?).to be true
    end
    it 'does not fail if user has no payment account' do
      user.payment_account = nil
      expect(user.trialing?).to be false
    end
  end

  describe '.not_in_team' do
    let(:team) { create :team }
    before do
      User.delete_all
    end
    it do
      @not_in_team_users = create_list :user, 10, team_id: nil
      @team_users = create_list :user, 10, team_id: team.id
      expect( User.all ).to have(20).items
      expect( User.not_in_team ).to have(10).items
      expect ( User.not_in_team.reject { |u| u.team_id.nil? }.empty? )
    end
  end

  # Instance methods
  subject { create :user }
  its(:account_activated?) { is_expected.to be true }
  its(:generate_account_activation_token) { is_expected.to_not be nil }
  its(:activate_account!) { is_expected.to be true }
end
