class ReturnsController <ApplicationController
  def create
    FindReturnableOrder.return_order(current_user, params[:order_id])

    redirect_to employees_path
  end
end
