require 'rails_helper'

RSpec.describe ReceiveReturnProduct do
  describe '#run' do
    let(:employee) { create(:employee, :warehouse) }
    let(:product) { create(:product) }
    let(:order) { create(:order, line_items: [build(:order_line_item, product:, quantity: 3)]) }

    before do
      # Get returned order so that employee can place it on shelf
      ReceiveProduct.run(employee, product, 5) # on_shelf ->5
      FindFulfillableOrder.fulfill_order(employee, order.id) # on_shelf -> 2
      FindReturnableOrder.return_order(employee, order.id)
      product.reload
    end

    it 'update objects accordingly' do
      # Ensure that inventories are initially returned
      order_inventories = Inventory.returned.where(product_id: product.id)
      order_inventory_ids = order_inventories.ids

      expect do
        ReceiveReturnProduct.run(employee, product, 3)
      end.to change { product.on_shelf }.from(2).to(5)
      # Ensure that inventories are moved on shelf
      expect(Inventory.where(id: order_inventory_ids).pluck(:status).uniq).to eq(['on_shelf'])
    end
  end
end
