class ItemsController < ApplicationController
  before_action :authenticate_admin!

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(params.require(:item).permit(:sku, :height, :width, :length, :weight))
    @distance = params[:item]['Distância (km)']

    if @item.save && @distance.present?
      redirect_to generated_quotes_path(i: @item.sku, d: @distance)
    else
      @item.convert_g_to_kg
      @item.errors.add(:base, 'Distância (km) não pode ficar em branco') if @distance.blank?
      flash.now[:error] = 'Dados inválidos...'
      render 'new'
    end
  end
end
