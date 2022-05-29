require 'rails_helper'

describe 'Administrador cria uma ordem de serviço' do
  it 'a partir de uma cotação' do
    admin = Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br',
                          password: 'whatshisname')
    sc = ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                 brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                 street_name: 'Avenida Felipe Camarão', street_number: '100', complement: 'Galpão 10',
                                 district: 'Industrial', city: 'Mossoró', state: 'RN', postal_code: '59000000')
    ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.50,
                          shipping_company: first_sc)
    ShippingDeadline.create!(start_distance: 0, end_distance: 500, deadline: 4, shipping_company: first_sc)

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
    click_on 'Criar Ordem de Serviço'

    within('h2') do
      expect(page).to have_content 'Nova Ordem de Serviço'
    end
    within('div#remitter') do
      expect(page).to have_content 'Endereço para retirada'
      expect(page).to have_field 'Logradouro'
      expect(page).to have_field 'Número'
      expect(page).to have_field 'Complemento'
      expect(page).to have_field 'Bairro'
      expect(page).to have_field 'Cidade'
      expect(page).to have_field 'Estado'
      expect(page).to have_field 'CEP'
    end
    within('div#remittee') do
      expect(page).to have_content 'Informações para entrega'
      expect(page).to have_content 'Destinatário'
      expect(page).to have_field 'Nome'
      expect(page).to have_field 'Sobrenome'
      expect(page).to have_content 'Endereço'
      expect(page).to have_field 'Logradouro'
      expect(page).to have_field 'Número'
      expect(page).to have_field 'Complemento'
      expect(page).to have_field 'Bairro'
      expect(page).to have_field 'Cidade'
      expect(page).to have_field 'Estado'
      expect(page).to have_field 'CEP'
    end
  end
end
