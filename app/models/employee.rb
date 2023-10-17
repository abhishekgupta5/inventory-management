class Employee < ApplicationRecord
  enum role: { warehouse: 'warehouse', customer_service: 'customer_service' }.freeze
  validates :name, presence: true
  validates :access_code, uniqueness: true
end
