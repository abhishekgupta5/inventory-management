require 'rails_helper'

RSpec.feature 'Returned order address update' do
  scenario 'updates address for a returned order' do
    warehouse_employee, cs_employee, order = ensure_returned_order_with_product
    address = order.ships_to

    # Signin as a warehouse employee
    employee_signin(warehouse_employee)
    # Ensure that return order is present
    expect(page).to have_returned_order(order)

    click_on sign_out

    # Signin as a customer service employee
    employee_signin(cs_employee)

    # Ensure that returned order customer is in the list
    expect(page).to have_content I18n.t('.employees.customer_service.returned_customers.header')
    expect(page).to have_content(address.recipient)

    # Ensure that current address is shown for the customer
    find("tr[data-id='address-#{address.id}'] td a").click
    expect(page).to have_content I18n.t('addresses.show.address.current_address')

    # Update any field of the address
    click_link('Edit')
    expect(page).to have_content I18n.t('addresses.edit.address.edit_address')
    fill_in('address[street_1]', with: 'address line 1')
    click_button('Update Address')

    # Ensure that address was updated successfully
    expect(page).to have_content('Address was successfully updated')

    # Ensure that returned order customer is removed from the list
    visit employees_path
    expect(page).to have_content('No addresses to be fixed')
  end

  def ensure_returned_order_with_product
    warehouse_employee = create(:employee, :warehouse, access_code: '12345')
    cs_employee = create(:employee, :customer_service, access_code: '54321')
    product = create(:product)
    order = create(:order, line_items: [build(:order_line_item, product:, quantity: 5)])
    ReceiveProduct.run(warehouse_employee, product, 10)
    FindFulfillableOrder.fulfill_order(warehouse_employee, order.id)
    FindReturnableOrder.return_order(warehouse_employee, order.id)
    [warehouse_employee, cs_employee, order.reload]
  end

  def employee_signin(role)
    visit root_path
    click_on sign_in
    attempt_code(role.warehouse? ? '12345' : '54321')
  end

  def sign_out
    I18n.t('layouts.application.sign_out')
  end
end
