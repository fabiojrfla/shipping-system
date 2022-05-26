require 'rails_helper'

describe 'Usuário cadastra preços mínimos' do
  it 'se estiver autenticado' do
    visit new_min_shipping_price_path

    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                            brand_name: 'TransLight', email: 'contato@translight.com.br',
                            street_name: 'Avenida Alberto Maranhão', street_number: '100', complement: 'Galpão 10',
                            district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000000')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')

    login_as(user, scope: :user)
    visit user_root_path
    click_on 'Tabela de Preços'
    within('section#minimum-prices') do
      click_on 'Novo Preço'
    end
    fill_in 'Distância Inicial (km)', with: '0'
    fill_in 'Distância Final (km)', with: '100'
    fill_in 'Valor (R$)', with: '100'
    click_on 'Criar Preço mínimo'

    expect(current_path).to eq shipping_prices_path
    expect(page).to have_content 'Preço cadastrado com sucesso!'
    within('section#minimum-prices') do
      expect(page).to have_content '0-100km'
      expect(page).to have_content 'R$ 100,00'
    end
  end
end
