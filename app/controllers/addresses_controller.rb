class AddressesController < ApplicationController
  before_action :require_signin

  def show
    @address = Address.find(params[:id])
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    if @address.update({fixed: true}.merge(address_params))
      redirect_to @address, notice: 'Address was successfully updated.'
    else
      flash[:alert] = 'Address could not be updated due to errors.'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def address_params
    params.require(:address).permit(:recipient, :street_1, :street_2, :city, :state, :zip)
  end
end
