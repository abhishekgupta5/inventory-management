class Product < ApplicationRecord
  validates :name, presence: true
  validates :on_shelf, presence: true
  monetize :price_cents
  has_many :inventory

  def self.returned_products_inventory_map
    Inventory.returned.group(:product).count
  end

  def in_stock_count
    inventory.on_shelf.count
  end

  def needed_inventory_count
    self.class.connection.select_value(<<~SQL)
      SELECT GREATEST(
        SUM(order_line_items.quantity) - #{on_shelf}, 0)
      FROM order_line_items
        LEFT OUTER JOIN inventories
          ON order_line_items.order_id = inventories.order_id
      WHERE order_line_items.product_id = #{id}
        AND inventories.order_id IS NULL
    SQL
  end
end
