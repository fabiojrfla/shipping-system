class ServiceOrdersController < ApplicationController
  def new
    @quote = [Quote.find_by(code: params[:q])]
    @service_order = ServiceOrder.new
    @service_order.build_address
    remittee = @service_order.build_remittee
    remittee.build_address
  end

  def create
    @service_order = ServiceOrder.new(service_order_params)
    if @service_order.save
      flash[:success] = 'Ordem de Serviço criada com sucesso!'
      redirect_to @service_order
    else
      @quote = [Quote.find(@service_order.quote_id)]
      flash.now[:error] = 'Dados inválidos...'
      render 'new'
    end
  end

  def show
    @service_order = ServiceOrder.find(params[:id])
  end

  def index
    @service_orders = ServiceOrder.order(created_at: :desc)
  end

  private

  def service_order_params
    params
      .require(:service_order)
      .permit(:quote_id,
              address_attributes: %i[street_name street_number complement district city state postal_code],
              remittee_attributes: [:id_number, :name, :surname,
                                    { address_attributes: %i[street_name street_number complement district city state
                                                             postal_code] }])
  end
end
