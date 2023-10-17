class Address < ApplicationRecord
  validates :recipient, :street_1, :city, :state, :zip, presence: true

  def self.to_fix
    Address.where(fixed: false)
  end
end
