require 'rails_helper'

describe 'Usuário cadastra preços' do
  it 'com sucesso' do
    ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                            brand_name: 'TransLight', email: 'contato@translight.com.br',
                            street_name: 'Avenida Alberto Maranhão', street_number: '100', complement: 'Galpão 10',
                            district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000000')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')

    login_as(user, scope: :user)
    visit user_root_path
    click_on 'Tabela de Preços'
    click_on 'Novo Preço'
    fill_in 'Volume Inicial (cm³)', with: '0'
    fill_in 'Volume Final (cm³)', with: '50'
    fill_in 'Peso Inicial (kg)', with: '0'
    fill_in 'Peso Final (kg)', with: '10'
    fill_in 'Valor por KM (R$)', with: '0.50'
    click_on 'Criar Preço'

    expect(current_path).to eq shipping_prices_path
    expect(page).to have_content 'Preço cadastrado com sucesso!'
    within('table') do
      expect(page).to have_content '0-50'
      expect(page).to have_content '0-10'
      expect(page).to have_content 'R$ 0,50'
    end
  end

  it 'com dados inválidos' do
    ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                            brand_name: 'TransLight', email: 'contato@translight.com.br',
                            street_name: 'Avenida Alberto Maranhão', street_number: '100', complement: 'Galpão 10',
                            district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000000')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')

    login_as(user, scope: :user)
    visit user_root_path
    click_on 'Tabela de Preços'
    click_on 'Novo Preço'
    fill_in 'Volume Inicial (cm³)', with: '0'
    fill_in 'Volume Final (cm³)', with: ''
    fill_in 'Peso Inicial (kg)', with: '0'
    fill_in 'Peso Final (kg)', with: ''
    fill_in 'Valor por KM (R$)', with: '0.50'
    click_on 'Criar Preço'

    expect(page).to have_content 'Dados inválidos...'
    expect(page).to have_content 'Volume Final (cm³) não pode ficar em branco'
    expect(page).to have_content 'Peso Final (kg) não pode ficar em branco'

    expect(page).not_to have_content 'Volume Inicial (cm³) não pode ficar em branco'
    expect(page).not_to have_content 'Peso Inicial (kg) não pode ficar em branco'
    expect(page).not_to have_content 'Valor por KM (R$) não pode ficar em branco'

    expect(page).to have_field 'Volume Inicial (cm³)', with: '0'
    expect(page).to have_field 'Valor por KM (R$)', with: '0.50'
  end

  it 'com intervalos já contemplados' do
    sc = ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                                 brand_name: 'TransLight', email: 'contato@translight.com.br',
                                 street_name: 'Avenida Alberto Maranhão', street_number: '100',
                                 complement: 'Galpão 10', district: 'Centro', city: 'Mossoró', state: 'RN',
                                 postal_code: '59000000')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')
    ShippingPrice.create!(start_volume: 0, end_volume: 50, start_weight: 0, end_weight: 10, price_km: 0.50,
                          shipping_company: sc)

    login_as(user, scope: :user)
    visit user_root_path
    click_on 'Tabela de Preços'
    click_on 'Novo Preço'
    fill_in 'Volume Inicial (cm³)', with: '31'
    fill_in 'Volume Final (cm³)', with: '60'
    fill_in 'Peso Inicial (kg)', with: '6'
    fill_in 'Peso Final (kg)', with: '15'
    fill_in 'Valor por KM (R$)', with: '0.50'
    click_on 'Criar Preço'

    expect(page).to have_content 'Dados inválidos...'
    expect(page).to have_content 'Intervalos de volume e de peso já cadastrados'
  end
end
