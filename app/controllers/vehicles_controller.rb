class VehiclesController < ApplicationController
  def index
    @vehicles = current_user.shipping_company.vehicles
  end

  def new
    @vehicle = Vehicle.new
  end

  def create
    @vehicle = Vehicle.new(params.require(:vehicle).permit(:license_plate, :make, :model, :year, :max_load))
    @vehicle.shipping_company = current_user.shipping_company
    if @vehicle.save
      flash[:success] = 'Veículo cadastrado com sucesso!'
      redirect_to vehicles_path
    else
      flash.now[:error] = 'Dados inválidos...'
      render 'new'
    end
  end
end
