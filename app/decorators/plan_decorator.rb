class PlanDecorator < Draper::Decorator
  delegate_all

  def pretty_description
    if model == Plan.provider_per_request
      "#{model.description} -- #{pretty_price(Product.inquiry.a_la_carte_price_in_cents)} per inquiry"
    else
      "#{model.description} -- #{pretty_price(model.price_in_cents)}"
    end
  end

  def pretty_price(price = nil)
    price ||= model.price_in_cents
    h.number_to_currency(price / 100.0)
  end
end
