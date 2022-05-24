class ShippingCompaniesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_shipping_company, only: %i[show deactivate activate]

  def index
    @active_shipping_companies = ShippingCompany.where(status: 'active')
    @inactive_shipping_companies = ShippingCompany.where(status: 'inactive')
  end

  def new
    @shipping_company = ShippingCompany.new
  end

  def create
    @shipping_company = ShippingCompany.new(params.require(:shipping_company).permit(:registration_number,
                                                                                     :corporate_name, :brand_name,
                                                                                     :email, :street_name,
                                                                                     :street_number, :complement,
                                                                                     :district, :city, :state,
                                                                                     :postal_code))

    if @shipping_company.save
      flash[:success] = 'Transportadora cadastrada com sucesso!'
      redirect_to @shipping_company
    else
      flash.now[:error] = 'Dados incompletos...'
      render 'new'
    end
  end

  def show; end

  def deactivate
    @shipping_company.inactive!
    redirect_to shipping_companies_path
  end

  def activate
    @shipping_company.active!
    redirect_to shipping_companies_path
  end

  private

  def set_shipping_company
    @shipping_company = ShippingCompany.find(params[:id])
  end
end
