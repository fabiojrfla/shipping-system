require 'rails_helper'

describe 'Usuário vê veículos' do
  it 'com sucesso' do
    sc = ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                                 brand_name: 'TransLight', email: 'contato@translight.com.br',
                                 street_name: 'Avenida Alberto Maranhão', street_number: '100',
                                 complement: 'Galpão 10', district: 'Centro', city: 'Fortaleza', state: 'CE',
                                 postal_code: '60010010')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')
    Vehicle.create!(license_plate: 'LSN4I49', make: 'Ford', model: 'F-4000', year: '2002', max_load: 3_000,
                    shipping_company: sc)
    Vehicle.create!(license_plate: 'BEE4R22', make: 'Fiat', model: 'Fiorino', year: '2012', max_load: 600,
                    shipping_company: sc)

    login_as(user, scope: :user)
    visit user_root_path
    click_on 'Veículos'

    within('h2') do
      expect(page).to have_content 'Veículos'
    end
    within('table') do
      expect(page).to have_content 'Placa'
      expect(page).to have_content 'LSN4I49'
      expect(page).to have_content 'Marca'
      expect(page).to have_content 'Ford'
      expect(page).to have_content 'Modelo'
      expect(page).to have_content 'F-4000'
      expect(page).to have_content 'Ano de Fabricação'
      expect(page).to have_content '2002'
      expect(page).to have_content 'Capacidade Máxima (kg)'
      expect(page).to have_content '3000kg'
      expect(page).to have_content 'BEE4R22'
      expect(page).to have_content 'Fiat'
      expect(page).to have_content 'Fiorino'
      expect(page).to have_content '2012'
      expect(page).to have_content '600kg'
    end
    expect(page).not_to have_content 'Não existem veículos cadastrados'
  end

  it 'e não existem veículos cadastrados' do
    sc = ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                                 brand_name: 'TransLight', email: 'contato@translight.com.br',
                                 street_name: 'Avenida Alberto Maranhão', street_number: '100',
                                 complement: 'Galpão 10', district: 'Centro', city: 'Fortaleza', state: 'CE',
                                 postal_code: '60010010')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')

    login_as(user, scope: :user)
    visit user_root_path
    click_on 'Veículos'

    expect(page).to have_content 'Não existem veículos cadastrados'
    expect(page).not_to have_css 'table'
  end
end
