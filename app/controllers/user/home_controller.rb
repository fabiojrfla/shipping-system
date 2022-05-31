class User::HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @pending_service_orders = ServiceOrder.where(status: 'pending', shipping_company: @user.shipping_company)
                                          .order(created_at: :desc)
  end
end
