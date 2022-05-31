class ServiceOrdersController < ApplicationController
  devise_group :agent, contains: %i[user admin]
  before_action :authenticate_agent!, only: %i[index show]
  before_action :authenticate_admin!, only: %i[new create]
  before_action :authenticate_user!, only: %i[set_vehicle accept]
  before_action :set_service_order, only: %i[show set_vehicle accept]

  def new
    @quote = [Quote.find_by(code: params[:q])]
    @shipping_company = [@quote.first.shipping_company]
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
      @quote = [@service_order.quote]
      @shipping_company = [@service_order.shipping_company]
      flash.now[:error] = 'Dados inválidos...'
      render 'new'
    end
  end

  def show
    if user_signed_in? && current_user.shipping_company != @service_order.shipping_company
      redirect_to root_path
    end
  end

  def index
    if admin_signed_in?
      @pending_service_orders = ServiceOrder.where(status: 'pending').order(created_at: :desc)
      @accepted_service_orders = ServiceOrder.where(status: 'accepted').order(created_at: :desc)
      @rejected_service_orders = ServiceOrder.where(status: 'rejected').order(created_at: :desc)
    elsif user_signed_in?
      @pending_service_orders = ServiceOrder.where(status: 'pending', shipping_company: current_user.shipping_company)
                                            .order(created_at: :desc)
      @accepted_service_orders = ServiceOrder.where(status: 'accepted', shipping_company: current_user.shipping_company)
                                             .order(created_at: :desc)
      @rejected_service_orders = ServiceOrder.where(status: 'rejected', shipping_company: current_user.shipping_company)
                                             .order(created_at: :desc)
    end
  end

  def set_vehicle
    redirect_to root_path if current_user.shipping_company != @service_order.shipping_company
    @vehicles = current_user.shipping_company.vehicles
  end

  def accept
    service_order_params = params.require(:service_order).permit(:vehicle_id)
    if params[:service_order][:vehicle_id].present? && @service_order.update(service_order_params)
      @service_order.accepted!
      flash[:success] = 'Ordem de Serviço aceita!'
      redirect_to @service_order
    else
      flash.now[:error] = 'Dados inválidos...'
      render 'new'
    end
  end

  private

  def service_order_params
    params
      .require(:service_order)
      .permit(:quote_id, :shipping_company_id,
              address_attributes: %i[street_name street_number complement district city state postal_code],
              remittee_attributes: [:id_number, :name, :surname,
                                    { address_attributes: %i[street_name street_number complement district city state
                                                             postal_code] }])
  end

  def set_service_order
    @service_order = ServiceOrder.find(params[:id])
  end
end
