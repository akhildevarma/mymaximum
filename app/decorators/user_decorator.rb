class UserDecorator < Draper::Decorator
  delegate_all
  decorates_association :profile
  decorates_association :provider

  def full_name
    return nil unless model.profile.present?
    model.profile.decorate.full_name
  end

  def name
    return nil unless ( model.profile.present? && model.profile.first_name )
    model.profile.first_name
  end

  def phone_number
    model.profile && model.profile.phone_number || '-'
  end

  def activity_status
    model.account_activated? ? I18n.t('users.last_active_at') : I18n.t('users.invite_sent_at')
  end

  def role
    if model.student?
      I18n.t('roles.student')
    elsif model.provider?
      I18n.t('roles.provider')
    elsif model.patient?
      I18n.t('roles.patient')
    elsif model.administrator?
      I18n.t('roles.administrator')
    end
  end
end
