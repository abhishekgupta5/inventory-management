require 'rails_helper'

RSpec.describe FindReturnableOrder do
  describe '#process_return' do
    let(:employee) { create(:employee, :warehouse) }
    let(:product) { create(:product) }
    let(:order) { create(:order, line_items: [build(:order_line_item, product:, quantity: 2)]) }

    before do
      # Fulfill order so that it can be returned
      ReceiveProduct.run(employee, product, 2)
      FindFulfillableOrder.fulfill_order(employee, order.id)
    end

    it 'update objects accordingly' do
      # Ensure that inventories are shipped
      order_inventories = order.inventories
      expect(order_inventories.pluck(:status).uniq).to eq(['shipped'])
      order_inventory_ids = order_inventories.ids

      expect do
        FindReturnableOrder.return_order(employee, order.id)
      end.to change { order.reload.state }.from('fulfilled').to('returned')
      # Ensure that inventories are returned and disassociated with the order
      expect(Inventory.where(id: order_inventory_ids, order: nil).pluck(:status).uniq).to eq(['returned'])
    end
  end
end
