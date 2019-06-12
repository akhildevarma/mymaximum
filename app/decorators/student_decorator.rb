class StudentDecorator < Draper::Decorator
  delegate_all
  decorates_association :user

  def email
    model.user.email
  end
end
