class Address < ApplicationRecord
  validates :recipient, :street_1, :city, :state, :zip, presence: true

  def self.all_returned_customers
    Address.where(id: Order.returned.pluck(:ships_to_id))
  end
end
