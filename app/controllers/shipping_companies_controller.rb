class ShippingCompaniesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @shipping_companies = ShippingCompany.all
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
      redirect_to shipping_companies_path
    else
      flash[:error] = 'Dados incompletos...'
      render 'new'
    end
  end
end
