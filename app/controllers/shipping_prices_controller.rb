class ShippingPricesController < ApplicationController
  def index
    @shipping_prices = ShippingPrice.all
  end

  def new
    @shipping_price = ShippingPrice.new
  end

  def create
    @shipping_price = ShippingPrice.new(params.require(:shipping_price).permit(:start_volume, :end_volume,
                                                                               :start_weight, :end_weight, :price_km))
    @shipping_price.shipping_company = current_user.shipping_company

    if @shipping_price.save
      flash[:success] = 'Preço cadastrado com sucesso!'
      redirect_to shipping_prices_path
    else
      @shipping_price.start_weight = ''
      @shipping_price.end_weight = ''
      flash.now[:error] = 'Dados inválidos...'
      render 'new'
    end
  end
end
