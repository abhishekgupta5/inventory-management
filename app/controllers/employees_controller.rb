class EmployeesController < ApplicationController
  before_action :require_signin

  def index
    @fulfillable_orders = Order.fulfillable.limit(10)
    @recent_orders = Order.recent.limit(10)
    @returned_orders = Order.returned.limit(10)
    @products = Product.order(:id)
    @returned_products_inventory_map = Product.returned_products_inventory_map
  end
end
