require 'rails_helper'

describe 'provider_signups/new.html.erb' do
  def self.field_required(field_name, required = true)
    field_name = field_name.to_s.titleize
    description = [field_name, (required ? '' : 'not'), 'required'].reject(&:blank?).join(' ')
    it description do
      expected = include("<abbr title=\"required\">*</abbr> #{field_name}")
      matcher = lambda { |req| req ? :to : :to_not }
      expect(subject).send(matcher.call(required), expected)
    end
  end
  def self.field_not_required(field_name)
    self.field_required(field_name, required=false)
  end

  before { @provider_signup = ProviderSignup.new }
  subject { render }

  describe 'signup form' do
    field_required :license_number
    
    context 'when user in team' do
      before { @user_in_team = true }
      field_not_required :license_number
    end
  end
end
