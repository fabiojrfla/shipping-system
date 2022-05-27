require 'rails_helper'

describe 'Administrador faz cotação de preços' do
  it 'se estiver autenticado' do
    visit new_item_path

    expect(current_path).to eq new_admin_session_path
  end

  it 'a partir do painel administrativo' do
    admin = Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br',
                          password: 'whatshisname')

    login_as(admin, scope: :admin)
    visit admin_root_path
    click_on 'Nova Cotação'

    expect(current_path).to eq new_item_path
    within('h2') do
      expect(page).to have_content 'Nova Cotação'
    end
    within('div#quote-form') do
      expect(page).to have_content 'Item a ser transportado'
      expect(page).to have_field 'SKU'
      expect(page).to have_field 'Altura (cm)'
      expect(page).to have_field 'Largura (cm)'
      expect(page).to have_field 'Comprimento (cm)'
      expect(page).to have_field 'Peso (kg)'
      expect(page).to have_content 'Distância a ser percorrida entre origem e destino'
      expect(page).to have_field 'Distância (km)'
    end
  end

  it 'com sucesso' do
    admin = Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br',
                          password: 'whatshisname')
    first_sc = ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                       brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                       street_name: 'Avenida Felipe Camarão', street_number: '100',
                                       complement: 'Galpão 10', district: 'Industrial', city: 'Mossoró', state: 'RN',
                                       postal_code: '59000000')
    second_sc = ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                                        brand_name: 'TransLight', email: 'contato@translight.com.br',
                                        street_name: 'Avenida Alberto Maranhão', street_number: '100',
                                        complement: 'Galpão 10', district: 'Centro', city: 'Fortaleza', state: 'CE',
                                        postal_code: '60010010')
    third_sc = ShippingCompany.create!(registration_number: '34567892000189', corporate_name: 'Ache Fretes LTDA',
                                       brand_name: 'Ache', email: 'contato@achefretes.com.br', status: 'inactive',
                                       street_name: 'Avenida Josefa Medeiros', street_number: '855',
                                       complement: 'Galpão 82', district: 'Centro', city: 'Natal', state: 'RN',
                                       postal_code: '59010000')
    ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.50,
                          shipping_company: first_sc)
    ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.45,
                          shipping_company: second_sc)
    ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.40,
                          shipping_company: third_sc)
    ShippingDeadline.create!(start_distance: 0, end_distance: 500, deadline: 4, shipping_company: first_sc)
    ShippingDeadline.create!(start_distance: 0, end_distance: 500, deadline: 5, shipping_company: second_sc)
    ShippingDeadline.create!(start_distance: 0, end_distance: 500, deadline: 6, shipping_company: third_sc)

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

    expect(current_path).to eq generated_quotes_path
    expect(page).to have_content 'Cotações para UGGBBPUR06'
    expect(page).to have_content '2 transportadoras encontradas'
    expect(page).to have_content 'TransLight'
    expect(page).to have_content 'R$ 225,00'
    expect(page).to have_content '5 dias úteis'
    expect(page).to have_content 'TExpress'
    expect(page).to have_content 'R$ 250,00'
    expect(page).to have_content '4 dias úteis'
    expect(page).not_to have_content 'Ache'
  end

  it 'e nenhuma transportadora atende os requisitos' do
    admin = Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br',
                          password: 'whatshisname')
    sc = ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                 brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                 street_name: 'Avenida Felipe Camarão', street_number: '100',
                                 complement: 'Galpão 10', district: 'Industrial', city: 'Mossoró', state: 'RN',
                                 postal_code: '59000000')
    ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.50,
                          shipping_company: sc)
    ShippingDeadline.create!(start_distance: 0, end_distance: 500, deadline: 4, shipping_company: sc)

    login_as(admin, scope: :admin)
    visit admin_root_path
    click_on 'Nova Cotação'
    fill_in 'SKU', with: 'UGGBBPUR06'
    fill_in 'Altura (cm)', with: '70'
    fill_in 'Largura (cm)', with: '50'
    fill_in 'Comprimento (cm)', with: '90'
    fill_in 'Peso (kg)', with: '15'
    fill_in 'Distância (km)', with: '300'
    click_on 'Cotar'

    expect(page).to have_content 'Nenhuma transportadora atende esses requisitos'
    expect(page).not_to have_content 'TExpress'
  end

  it 'com dados inválidos' do
    admin = Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br',
                          password: 'whatshisname')

    login_as(admin, scope: :admin)
    visit admin_root_path
    click_on 'Nova Cotação'
    fill_in 'SKU', with: ''
    fill_in 'Altura (cm)', with: '70'
    fill_in 'Largura (cm)', with: ''
    fill_in 'Comprimento (cm)', with: '90'
    fill_in 'Peso (kg)', with: ''
    fill_in 'Distância (km)', with: '300'
    click_on 'Cotar'

    expect(page).to have_content 'Dados inválidos...'
    expect(page).to have_content 'SKU não pode ficar em branco'
    expect(page).to have_content 'Largura (cm) não pode ficar em branco'
    expect(page).to have_content 'Peso (kg) não pode ficar em branco'

    expect(page).not_to have_content 'Altura (cm) não pode ficar em branco'
    expect(page).not_to have_content 'Comprimento (cm) não pode ficar em branco'
    expect(page).not_to have_content 'Distância (km) não pode ficar em branco'

    expect(page).to have_field 'Altura (cm)', with: '70'
    expect(page).to have_field 'Comprimento (cm)', with: '90'
    expect(page).to have_field 'Distância (km)', with: '300'
  end
end
