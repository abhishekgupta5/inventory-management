class Order < ApplicationRecord
  enum state: {
    in_progress: 'in_progress',
    fulfilled: 'fulfilled',
    returned: 'returned'
  }.freeze

  belongs_to :ships_to, class_name: 'Address'
  has_many :line_items, class_name: 'OrderLineItem'
  has_many :inventories

  scope :recent, -> { order(created_at: :desc) }

  scope :fulfillable, lambda {
    in_progress
      .joins(:line_items)
      .joins(<<~SQL)
        LEFT OUTER JOIN products
        ON order_line_items.product_id = products.id
    SQL
      .group(:id)
      .having(<<~SQL)
        COUNT(DISTINCT order_line_items.product_id) =
        SUM(CASE WHEN order_line_items.quantity <= products.on_shelf THEN 1 ELSE 0 END)
    SQL
      .order(:created_at, :id)
  }

  def cost
    line_items.inject(Money.zero) do |acc, li|
      acc + li.cost
    end
  end

  # BUG: With the original code, an order with no line item will also be
  # fulfillable while it shouldn't be

  # Fix-1:
  # We can have a presence check first and then only check line items.
  # This fix has been implemented in the method below

  # Fix-2:
  # Another possible way to address this is to think about whether there can even
  # be an order with no line item from a business/product perspective?
  # In most eCommerce systems, an order is generally associated with at least 1 line item,
  # then only it makes sense to call it an order and process it further.
  # The way to technically implement this can be to add a custom validation for order
  # Something like this -
  #
  # class Order ...
  #   validate :at_least_one_line_item
  #   private
  #   def at_least_one_line_item
  #     if line_items.blank?
  #       errors.add(:order, "Order should have at least 1 line item")
  #     end
  #   end
  # end
  def fulfillable?
    in_progress? && line_items.present? && line_items.all?(&:fulfillable?)
  end
end
