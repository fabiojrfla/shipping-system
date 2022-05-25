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
    within('table') do
      expect(page).to have_content '0-50'
      expect(page).to have_content '0-10'
      expect(page).to have_content 'R$ 0,50'
    end
  end
end
