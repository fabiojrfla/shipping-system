require 'rails_helper'

describe 'Usuário vê preços' do
  it 'se estiver autenticado' do
    visit shipping_prices_path

    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    sc = ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                                 brand_name: 'TransLight', email: 'contato@translight.com.br',
                                 street_name: 'Avenida Alberto Maranhão', street_number: '100',
                                 complement: 'Galpão 10', district: 'Centro', city: 'Mossoró', state: 'RN',
                                 postal_code: '59000000')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')
    ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.50,
                          shipping_company: sc)
    ShippingPrice.create!(start_volume: 0.5, end_volume: 1, start_weight: 10, end_weight: 30,
                          price_km: 2, shipping_company: sc)

    login_as(user, scope: :user)
    visit user_root_path
    click_on 'Tabela de Preços'

    within('h2') do
      expect(page).to have_content 'Tabela de Preços'
    end
    within('table') do
      expect(page).to have_content '0.0-0.5m³'
      expect(page).to have_content '0-10kg'
      expect(page).to have_content 'R$ 0,50'
      expect(page).to have_content '0.5-1.0m³'
      expect(page).to have_content '10-30kg'
      expect(page).to have_content 'R$ 2,00'
    end
    within('section#prices-per-item') do
      expect(page).not_to have_content 'Não existem preços cadastrados'
    end
  end

  it 'por item e mínimos por distância' do
    sc = ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                                 brand_name: 'TransLight', email: 'contato@translight.com.br',
                                 street_name: 'Avenida Alberto Maranhão', street_number: '100',
                                 complement: 'Galpão 10', district: 'Centro', city: 'Mossoró', state: 'RN',
                                 postal_code: '59000000')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')
    ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.50,
                          shipping_company: sc)
    MinShippingPrice.create!(start_distance: 0, end_distance: 100, price: 100, shipping_company: sc)

    login_as(user, scope: :user)
    visit user_root_path
    click_on 'Tabela de Preços'

    within('section#prices-per-item') do
      expect(page).to have_content 'Por item'
      expect(page).to have_content 'Volume (m³)'
      expect(page).to have_content '0.0-0.5m³'
      expect(page).to have_content 'Peso (kg)'
      expect(page).to have_content '0-10kg'
      expect(page).to have_content 'Preço por km'
      expect(page).to have_content 'R$ 0,50'
    end

    within('section#minimum-prices') do
      expect(page).to have_content 'Mínimos por distância'
      expect(page).to have_content 'Distância (km)'
      expect(page).to have_content '0-100km'
      expect(page).to have_content 'Preço mínimo'
      expect(page).to have_content 'R$ 100,00'
    end
  end

  it 'e não existem preços cadastrados' do
    ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                            brand_name: 'TransLight', email: 'contato@translight.com.br',
                            street_name: 'Avenida Alberto Maranhão', street_number: '100', complement: 'Galpão 10',
                            district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000000')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')

    login_as(user, scope: :user)
    visit user_root_path
    click_on 'Tabela de Preços'

    within('section#prices-per-item') do
      expect(page).to have_content 'Não existem preços cadastrados'
    end
    within('section#minimum-prices') do
      expect(page).to have_content 'Não existem preços cadastrados'
    end
  end
end
