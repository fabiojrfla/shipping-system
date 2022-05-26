class ShippingDeadlinesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_shipping_company, only: %i[index create]

  def index
    @shipping_deadlines = @shipping_company.shipping_deadlines
  end

  def new
    @shipping_deadline = ShippingDeadline.new
  end

  def create
    @shipping_deadline = ShippingDeadline.new(params.require(:shipping_deadline).permit(:start_distance, :end_distance,
                                                                                        :deadline))
    @shipping_deadline.shipping_company = @shipping_company

    if @shipping_deadline.save
      flash[:success] = 'Prazo cadastrado com sucesso!'
      redirect_to shipping_deadlines_path
    else
      flash.now[:error] = 'Dados inválidos...'
      render 'new'
    end
  end

  private

  def set_shipping_company
    @shipping_company = current_user.shipping_company
  end
end
