class PaymentAccountDecorator < Draper::Decorator
  delegate_all

  def should_show_a_la_carte_prices?
    !model.trialing? && model.plan == Plan.a_la_carte
  end

  def pretty_last_four_digits
    format('%04d', model.last_four_digits) if model.last_four_digits
  end
end
