desc "Remove payment accounts from patients"
task :remove_patient_payment_account => :environment do
  Patient.all do |p|
    pa = p.user.payment_account
    if pa && pa.stripe_customer_token
      stripe_customer = Stripe::Customer.retrieve(pa.stripe_customer_token)
      stripe_customer.delete

      pa.destroy
    end
  end
end