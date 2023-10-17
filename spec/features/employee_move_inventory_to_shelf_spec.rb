require 'rails_helper'

RSpec.feature 'Employee move inventory to shelf' do
  scenario 'successfully' do
    order, product = ensure_returned_order_with_product

    visit root_path
    click_on sign_in
    attempt_code('12345')
    expect(page).to have_returned_order(order)
    # Initially, 5 are already on shelf, and 5 are available to be placed from returned products
    expect(page).to have_css("tr[data-id='move-to-shelf-product-#{product.id}'] div",
                             text: '5 returned (available to place on shelf)')
    expect(page).to have_css("tr[data-id='move-to-shelf-product-#{product.id}'] div", text: '5 on shelf')

    visit employees_path

    move_to_shelf(product, 4)
    # 4 moved from returned to shelf
    expect(page).to have_css("tr[data-id='move-to-shelf-product-#{product.id}'] div",
                             text: '1 returned (available to place on shelf)')
    expect(page).to have_css("tr[data-id='move-to-shelf-product-#{product.id}'] div", text: '9 on shelf')
  end

  def move_to_shelf(product, quantity)
    within("[data-id='move-to-shelf-product-#{product.id}'] form") do
      fill_in I18n.t('helpers.label.receive_product.quantity'), with: quantity
      click_on I18n.t('helpers.submit.receive_return_product.submit')
    end
  end

  def ensure_returned_order_with_product
    employee = create(:employee, :warehouse, access_code: '12345')
    product = create(:product)
    order = create(:order, line_items: [build(:order_line_item, product:, quantity: 5)])
    ReceiveProduct.run(employee, product, 10)
    FindFulfillableOrder.fulfill_order(employee, order.id)
    FindReturnableOrder.return_order(employee, order.id)
    [order.reload, product.reload]
  end
end
