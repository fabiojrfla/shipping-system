class ItemsController < ApplicationController
  before_action :authenticate_admin!

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(params.require(:item).permit(:sku, :height, :width, :length, :weight))
    distance = params[:item]['Distância (km)']

    if @item.save && distance.present?
      redirect_to generated_quotes_path(item: @item.id, distance: distance)
    else
      flash.now[:error] = 'Dados inválidos...'
      render 'new'
    end
  end
end
