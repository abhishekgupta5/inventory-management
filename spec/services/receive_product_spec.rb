require 'rails_helper'

RSpec.describe ReceiveProduct do
  describe '#run' do
    let(:employee) { create(:employee) }
    let(:product) { create(:product) }

    it 'update records properly' do
      Inventory.on_shelf.where(product_id: product.id).size
      expect do
        ReceiveProduct.run(employee, product, 2)
      end.to change { product.on_shelf }.from(0).to(2)
         .and change { Inventory.on_shelf.where(product_id: product.id).size }
         .by(2)
        .and change {
               InventoryStatusChange.where(status_to: :on_shelf).size
             }.by(2)
    end
  end
end
