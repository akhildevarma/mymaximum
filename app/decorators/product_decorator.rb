class ProductDecorator < Draper::Decorator
  delegate_all

  def pretty_price
    h.number_to_currency(model.a_la_carte_price_in_cents / 100.0)
  end
end
