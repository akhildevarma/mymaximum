class Product < ActiveRecord::Base
  # this class is essentially a reified lookup table

  scope :inquiry, -> { find_by_name!('inquiry') }
  scope :topic_search, -> { find_by_name!('topic_search') }

  validates :a_la_carte_price_in_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def a_la_carte_price_in_dollars
    a_la_carte_price_in_cents / 100.0
  end
end
