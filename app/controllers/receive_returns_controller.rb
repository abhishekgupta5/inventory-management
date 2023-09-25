class ReceiveReturnsController < ApplicationController
  before_action :require_signin

  def create
    ReceiveReturnProduct.run(current_user, product, product_quantity)
    redirect_to employees_path
  end

  private

  def product
    Product.find(params[:product_id])
  end

  def product_quantity
    Integer(params.require(:receive_return_product).permit(:quantity)[:quantity])
  end
end
