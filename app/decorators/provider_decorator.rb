class ProviderDecorator < Draper::Decorator
  delegate_all

  def specialty
    model.specialty || I18n.t('providers.specialty_na')
  end
end
