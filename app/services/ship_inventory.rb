class ShipInventory
  def self.run(employee, inventory_items, order, line_item)
    new(employee:, inventory_items:, order:, line_item:).run
  end

  def initialize(employee:, inventory_items:, order:, line_item:)
    @employee = employee
    @inventory_items = inventory_items
    @order = order
    @line_item = line_item
  end

  def run
    Inventory.transaction do
      inventory_items.each do |inventory|
        ship_inventory(inventory)
      end
      line_item.product.decrement!(:on_shelf, line_item.quantity)
    end
  end

  private

  attr_reader :employee, :inventory_items, :order, :line_item

  def ship_inventory(inventory)
    inventory.with_lock do
      InventoryStatusChange.create!(
        inventory:,
        status_from: inventory.status,
        status_to: :shipped,
        actor: employee
      )
      inventory.update!(status: :shipped, order:)
    end
  end
end
