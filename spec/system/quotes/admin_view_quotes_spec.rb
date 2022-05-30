require 'rails_helper'

describe 'Administrador vê cotações' do
  it 'com sucesso' do
    admin = Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br',
                          password: 'whatshisname')
    first_sc = ShippingCompany.create!(registration_number: '12345678000102',
                                       corporate_name: 'Transporte Expresso LTDA', brand_name: 'TExpress',
                                       email: 'contato@texpress.com.br', street_name: 'Avenida Felipe Camarão',
                                       street_number: '100', complement: 'Galpão 10', district: 'Industrial',
                                       city: 'Mossoró', state: 'RN', postal_code: '59000000')
    second_sc = ShippingCompany.create!(registration_number: '98765432000198',
                                        corporate_name: 'Light Transportes LTDA', brand_name: 'TransLight',
                                        email: 'contato@translight.com.br', street_name: 'Avenida Alberto Maranhão',
                                        street_number: '100', complement: 'Galpão 10', district: 'Centro',
                                        city: 'Fortaleza', state: 'CE', postal_code: '60010010')
    ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.50,
                          shipping_company: first_sc)
    ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.45,
                          shipping_company: second_sc)
    ShippingDeadline.create!(start_distance: 0, end_distance: 500, deadline: 4, shipping_company: first_sc)
    ShippingDeadline.create!(start_distance: 0, end_distance: 500, deadline: 5, shipping_company: second_sc)

    login_as(admin, scope: :admin)
    visit admin_root_path
    click_on 'Nova Cotação'
    fill_in 'SKU', with: 'UGGBBPUR06'
    fill_in 'Altura (cm)', with: '70'
    fill_in 'Largura (cm)', with: '50'
    fill_in 'Comprimento (cm)', with: '90'
    fill_in 'Peso (kg)', with: '5'
    fill_in 'Distância (km)', with: '500'
    click_on 'Cotar'
    click_on 'Painel Administrativo'
    click_on 'Cotações'

    within('h2') do
      expect(page).to have_content 'Cotações'
    end
    within('table') do
      expect(page).to have_content 'Data'
      expect(page).to have_content I18n.l(Time.current.to_date)
      expect(page).to have_content 'Código'
      expect(page).to have_content Quote.first.code
      expect(page).to have_content 'Item'
      expect(page).to have_content 'UGGBBPUR06'
      expect(page).to have_content 'Transportadora'
      expect(page).to have_content 'TransLight'
      expect(page).to have_content 'Preço'
      expect(page).to have_content 'R$ 225,00'
      expect(page).to have_content 'Prazo'
      expect(page).to have_content '5 dias úteis'
      expect(page).to have_content Quote.last.code
      expect(page).to have_content 'TExpress'
      expect(page).to have_content 'R$ 250,00'
      expect(page).to have_content '4 dias úteis'
      expect(page).to have_link 'Criar Ordem de Serviço'
    end
    expect(page).not_to have_content 'Ainda não foram geradas cotações'
  end

  it 'e ainda não foram geradas cotações' do
    admin = Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br',
                          password: 'whatshisname')

    login_as(admin, scope: :admin)
    visit admin_root_path
    click_on 'Cotações'

    expect(page).to have_content 'Ainda não foram geradas cotações'
    expect(page).not_to have_css 'table'
  end
end
