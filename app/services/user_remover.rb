require_relative 'stripe_customer_remover'

class UserRemover
  def self.run(id)
    new(id).run
  end

  def initialize(id, user_list: User, customer_remover: StripeCustomerRemover)
    @customer_remover = customer_remover
    @id = id
    @user_list = user_list
  end

  def run
    customer_remover.run(user.payment_account)
    user.destroy
  end

  private

  attr_reader :customer_remover, :id, :user_list

  def user
    @user ||= user_list.find(id)
  end
end
