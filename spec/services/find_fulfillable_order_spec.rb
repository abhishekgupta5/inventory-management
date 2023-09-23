require 'rails_helper'

RSpec.describe FindFulfillableOrder do
  it 'returns the oldest fulfillable order available' do
    employee = create(:employee)
    product = create(:product)

    ReceiveProduct.run(employee, product, 5)
    order = create(:order, line_items: [build(:order_line_item, product:, quantity: 2)])
    second_order = create(:order, line_items: [build(:order_line_item, product:, quantity: 2)])

    expect(Order.fulfilled).to be_empty

    expect do
      FindFulfillableOrder.begin_fulfillment(employee)
    end.to change { product.reload.on_shelf }.from(5).to(3)

    expect(Order.fulfilled).to match_array([order])

    expect do
      FindFulfillableOrder.begin_fulfillment(employee)
    end.to change { product.reload.on_shelf }.from(3).to(1)

    expect(Order.fulfilled).to match_array([order, second_order])

    expect(FindFulfillableOrder.begin_fulfillment(employee)).to be_nil
  end
end
