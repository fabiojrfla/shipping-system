class MinShippingPricesController < ApplicationController
  before_action :authenticate_user!

  def new
    @min_shipping_price = MinShippingPrice.new
  end

  def create
    @min_shipping_price = MinShippingPrice.new(params.require(:min_shipping_price).permit(:start_distance,
                                                                                          :end_distance, :price))
    @min_shipping_price.shipping_company = current_user.shipping_company

    if @min_shipping_price.save
      flash[:success] = 'Preço cadastrado com sucesso!'
      redirect_to shipping_prices_path
    else
      flash.now[:error] = 'Dados inválidos...'
      render 'new'
    end
  end
end
