require 'rails_helper'

RSpec.describe Order do
  describe '#fulfillable?' do
    let(:order) { create(:order) }
    let(:product) { create(:product, on_shelf: 5) }

    it 'should not be fulfillable if there is no line item' do
      expect(order.fulfillable?).to be_falsey
    end

    context 'when all line_items are fulfillable' do
      it 'order should be fulfillable' do
        create(:order_line_item, order:, product:, quantity: 2)
        expect(order.fulfillable?).to be_truthy
      end
    end

    context 'when line_items are not fulfillable' do
      it 'order should not be fulfillable' do
        create(:order_line_item, order:, product:, quantity: 10)
        expect(order.fulfillable?).to be_falsey
      end
    end
  end
end
