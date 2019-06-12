inquiry = Product.where(name: 'inquiry').first_or_initialize
inquiry.update_attributes!(a_la_carte_price_in_cents: 2999)

topic_search = Product.where(name: 'topic_search').first_or_initialize
topic_search.update_attributes!(a_la_carte_price_in_cents: 199)

 unless ApplicationSettings.count > 0
   application_settings = ApplicationSettings.find_or_create_by(require_general_invitations: false, allow_promo_code: true)
 end

a_la_carte = Plan.where(name: 'a_la_carte').first_or_initialize
a_la_carte.update_attributes!(price_in_cents: 0, interval: 'week', description: 'Pay per request')

provider_monthly = Plan.where(name: 'provider_monthly').first_or_initialize
provider_monthly.update_attributes!(price_in_cents: 2499, interval: 'month', description: 'Unlimited monthly')

provider_yearly = Plan.where(name: 'provider_yearly').first_or_initialize
provider_yearly.update_attributes!(price_in_cents: 24999, interval: 'yearly', description: 'Unlimited yearly')

provider_per_request = Plan.where(name: 'pay_per_request').first_or_initialize
provider_per_request.update_attributes!(price_in_cents: 0, interval: 'week', description: 'Provider pay per request')
