module OrdersHelper
  def have_fulfillable_order(order)
    have_css("[data-id=order-#{order.id}]", text: 'Fulfillable')
  end

  def have_unfulfillable_order(order)
    have_css("[data-id=order-#{order.id}]", text: 'Unfulfillable')
  end

  def have_fulfilled_order(order)
    have_css("[data-id=order-#{order.id}]", text: 'Fulfilled')
  end

  def have_returned_order(order)
    have_css("[data-id=order-#{order.id}]", text: 'Returned')
  end

  def view_order(order)
    find("[data-id=order-#{order.id}] a", match: :first).click
  end

  def fulfill_order
    click_on(I18n.t('orders.show.fulfill_order'))
  end

  def return_order
    click_on(I18n.t('orders.show.mark_as_returned'))
  end

  def allow_fulfillment
    have_css('button#fulfill_order_button:not(:disabled)')
  end

  def allow_return
    have_css('button:not([disabled="disabled"])', text: I18n.t('orders.show.mark_as_returned'))
  end
end

RSpec.configure do |config|
  config.include OrdersHelper, type: :feature
end
