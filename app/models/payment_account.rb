class PaymentAccount < ActiveRecord::Base
  PILOT_PROGRAM_END_DATE = DateTime.parse('30 June 2014').utc.at_end_of_day

  belongs_to :user, inverse_of: :payment_account
  belongs_to :team, inverse_of: :payment_account
  belongs_to :plan
  belongs_to :referrer, class_name: 'User'

  attr_accessor :stripe_card_token
  attr_accessor :card_number
  attr_accessor :card_code
  attr_accessor :cardholder_name
  attr_accessor :cardholder_zip

  validates :user_id, presence: true, uniqueness: true
  validates :plan_id, presence: true
  validate :valid_plan_for_user_role

  before_update :update_stripe_subscription, if: :plan_id_changed?
  before_update :update_card_information, unless: -> { stripe_card_token.blank? }
  before_update :update_coupon_code, if: :coupon_code_changed?

  def save_with_payment!
    raise ActiveRecord::RecordInvalid.new(self) unless valid?
    begin
      if Stripe::Coupon.all.map { |c| c.id }.include? coupon_code
        customer = Stripe::Customer.create(description: user.email, email: user.email, plan: plan.name, card: stripe_card_token, trial_end: trial_expires_at.to_i, coupon: coupon_code)
      else
        customer = Stripe::Customer.create(description: user.email, email: user.email, plan: plan.name, card: stripe_card_token, trial_end: trial_expires_at.to_i)
      end
      self.stripe_customer_token = customer.id
      save!
    rescue Stripe::StripeError => e
      self.stripe_card_token = nil
      errors.add :billing, 'There was a problem with your credit card.'
      logger.error e.message
      NewRelicRemote.report(e)
      raise ActiveRecord::RecordInvalid.new(self)
    end
  end

  def trial_expires_at
    ([PILOT_PROGRAM_END_DATE, (self.created_at || DateTime.now)].max + 90.days).utc.at_end_of_day
  end

  def trialing?
    !trial_expires_at.past?
  end

  def missing_credit_card?
    self.last_four_digits.blank?
  end

  def account_not_delinquent?
    Billing::SubscriptionBiller.new(self).user_not_delinquent?
  end

  private

  def update_stripe_subscription
    begin
      args = { plan: plan.name }
      args[:trial_end] = trial_expires_at.to_i if trialing?
      Stripe::Customer.retrieve(self.stripe_customer_token).update_subscription(args)
    rescue Stripe::StripeError => e
      errors.add :billing, 'There was a problem updating your subscription. Reload the page and try again.'
      logger.error e.message
      NewRelicRemote.report(e)
      return false
    end
  end

  def update_card_information
    begin
      cust = Stripe::Customer.retrieve(self.stripe_customer_token)
      cust.card = stripe_card_token
      saved_cust = cust.save
      self.last_four_digits = saved_cust.cards.data[0].last4
    rescue Stripe::StripeError => e
      errors.add :billing, 'There was a problem updating your card. Reload the page and try again.'
      logger.error e.message
      NewRelicRemote.report(e)
      return false
    end
  end

  def update_coupon_code
    begin
      cust = Stripe::Customer.retrieve(self.stripe_customer_token)
      if Stripe::Coupon.all.map { |c| c.id }.include? coupon_code
        cust.coupon = coupon_code
        cust.save
      end
    rescue Stripe::StripeError => e
      errors.add :billing, 'There was a problem updating your card. Reload the page and try again.'
      logger.error e.message
      NewRelicRemote.report(e)
      return false
    end
  end

  def valid_plan_for_user_role
    valid_plans = Plan.plans_for_user_role(user)
    unless valid_plans.map(&:id).include?(plan_id)
      errors[:plan_id] << 'not a valid plan'
    end
  end
end
