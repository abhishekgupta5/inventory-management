class ReturnInventory
  def self.run(employee, inventory_items, order)
    new(employee:, inventory_items:, order:).run
  end

  def initialize(employee:, inventory_items:, order:)
    @employee = employee
    @inventory_items = inventory_items
    @order = order
  end

  def run
    Inventory.transaction do
      inventory_items.each do |inventory|
        return_inventory(inventory)
      end
      order.returned!
      order.ships_to.update!(fixed: false)
    end
  end

  private

  attr_reader :employee, :inventory_items, :order

  def return_inventory(inventory)
    inventory.with_lock do
      InventoryStatusChange.create!(
        inventory:,
        status_from: inventory.status,
        status_to: :returned,
        actor: employee
      )
      inventory.update!(status: :returned, order: nil)
    end
  end
end
