class ReceiveReturnProduct
  def self.run(employee, product, quantity)
    new(employee:, product:, quantity:).run
  end

  def initialize(employee:, product:, quantity:)
    @employee = employee
    @product = product
    @quantity = quantity
  end

  def run
    Inventory.transaction do
      inventory_items = Inventory.returned.where(product_id: product.id).limit(quantity)
      inventory_items.each do |inventory|
        return_inventory_to_shelf(inventory)
      end
      product.increment!(:on_shelf, quantity)
    end
  end

  private

  attr_reader :employee, :product, :quantity

  def return_inventory_to_shelf(inventory)
    inventory.with_lock do
      InventoryStatusChange.create!(
        inventory:,
        status_from: inventory.status,
        status_to: :on_shelf,
        actor: employee
      )
      inventory.on_shelf!
    end
  end
end
