desc "Update old Stripe customers so their trials extend to the end of the pilot program (only needs to be run once ever)"
task :extend_trials_for_pilot_program => :environment do
  PaymentAccount.find_each do |payment_account|
    customer = Stripe::Customer.retrieve(payment_account.stripe_customer_token)
    customer.update_subscription(plan: payment_account.plan.name, trial_end: payment_account.trial_expires_at.to_i) # defer to the implementation in PaymentAccount, since it now takes pilot program end date into account
  end
end
