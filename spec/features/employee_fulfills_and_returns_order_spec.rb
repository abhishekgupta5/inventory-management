require 'rails_helper'

RSpec.feature 'Employee fulfills order and mark it as returned' do
  scenario 'successfully' do
    product = create(:product)
    employee = create(:employee, :warehouse, name: 'Jane Doe', access_code: '41315')
    ReceiveProduct.run(employee, product, 10)
    order = create(:order)
    create(:order_line_item, order:, product:, quantity: 5)

    visit root_path
    click_on sign_in
    attempt_code('41315')

    # Check fulfillment
    expect(page).to have_fulfillable_order(order)
    view_order(order)
    fulfill_order
    expect(page).to have_fulfilled_order(order)

    # Check return
    view_order(order)
    expect(page).not_to allow_fulfillment
    expect(page).to allow_return
    return_order
    expect(page).to have_returned_order(order)
    view_order(order)

    # Shouldn't return if already returned
    expect(page).not_to allow_return
  end
end
