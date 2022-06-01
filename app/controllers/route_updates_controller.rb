class RouteUpdatesController < ApplicationController
  def index
    @service_order = ServiceOrder.find(params[:service_order_id])
    @service_order.route_updates.build
  end

  def create
    @service_order = ServiceOrder.find(params[:service_order_id])
    service_order_params = params.require(:service_order).permit(:status,
                                                                 route_updates_attributes: %i[description place_name
                                                                                              city state])
    if @service_order.update(service_order_params)
      flash[:success] = 'Rota atualizada com sucesso!'
      redirect_to service_order_route_updates_path
    else
      @route_update = @service_order.route_updates.last
      flash.now[:error] = 'Dados inválidos...'
      render 'index'
    end
  end
end
