require 'rails_helper'

describe 'shared/_fullstory.html.erb' do
  before { allow(Rails.env).to receive_messages(production?: true) }
  context 'provider user' do
    before { set_current_user(view, :provider_user) }
    it 'properly renders' do
      render partial: 'shared/fullstory'
      id, display_name, email, specialty, user_type = view.current_user.as do |u|
        [
          u.id,
          u.full_name,
          u.email,
          u.try(:provider).try(:specialty),
          u.role
        ]
      end
      expect(rendered).to match('<script>')
      expect(rendered.gsub(/\s/, '')).to include(
        ''"
        FS.identify(#{id}, {
          displayName: '#{display_name}',
          email: '#{email}',
          provider: '#{specialty}',
          user_type: '#{user_type}'
        });
        "''.gsub(/\s/, '')
      )
    end
  end
  context 'student user' do
    before { set_current_user(view, :student_user) }
    it 'properly renders' do
      render partial: 'shared/fullstory'
      id, display_name, email, specialty, user_type = view.current_user.as do |u|
        [
          u.id,
          u.full_name,
          u.email,
          u.try(:provider).try(:specialty),
          u.role
        ]
      end
      expect(rendered.gsub(/\s/, '')).to include(
        ''"
        FS.identify(#{id}, {
          displayName: '#{display_name}',
          email: '#{email}',
          provider: '#{specialty}',
          user_type: '#{user_type}'
        });
        "''.gsub(/\s/, '')
      )
      expect(rendered).to match('<script>')
    end
  end

  def set_current_user(view, user_factory)
    view.class.module_eval { attr_accessor :current_user }
    view.current_user = FactoryGirl.build_stubbed(user_factory).decorate
  end
end
