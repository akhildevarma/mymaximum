class ProfileDecorator < Draper::Decorator
  delegate_all

  def full_name
    [model.first_name, model.middle_name, model.last_name, model.name_suffix].reject(&:blank?).join(' ')
  end

  def title_and_company
    return "#{model.name_title}" if model.company.blank?
    "#{model.name_title}, #{model.company}"
  end

  def location
    "#{model.city}, #{model.state}"
  end

  def phone_number
    h.number_to_phone(model.phone_number)
  end
end
