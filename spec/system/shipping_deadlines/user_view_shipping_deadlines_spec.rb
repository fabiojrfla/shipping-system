require 'rails_helper'

describe 'Usuário vê prazos' do
  it 'com sucesso' do
    sc = ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                                 brand_name: 'TransLight', email: 'contato@translight.com.br',
                                 street_name: 'Avenida Alberto Maranhão', street_number: '100',
                                 complement: 'Galpão 10', district: 'Centro', city: 'Mossoró', state: 'RN',
                                 postal_code: '59000000')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')
    ShippingDeadline.create!(start_distance: 0, end_distance: 100, deadline: 2, shipping_company: sc)
    ShippingDeadline.create!(start_distance: 100, end_distance: 300, deadline: 5, shipping_company: sc)

    login_as(user, scope: :user)
    visit user_root_path
    click_on 'Tabela de Prazos'

    within('h2') do
      expect(page).to have_content 'Tabela de Prazos'
    end
    within('table') do
      expect(page).to have_content 'Distância (km)'
      expect(page).to have_content '0-100km'
      expect(page).to have_content 'Dias úteis'
      expect(page).to have_content '2 dias'
      expect(page).to have_content 'Distância (km)'
      expect(page).to have_content '100-300km'
      expect(page).to have_content 'Dias úteis'
      expect(page).to have_content '5 dias'
      expect(page).not_to have_content 'Não existem prazos cadastrados'
    end
  end

  it 'e não existem prazos cadastrados' do
    ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                            brand_name: 'TransLight', email: 'contato@translight.com.br',
                            street_name: 'Avenida Alberto Maranhão', street_number: '100', complement: 'Galpão 10',
                            district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000000')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')

    login_as(user, scope: :user)
    visit user_root_path
    click_on 'Tabela de Prazos'

    expect(page).to have_content 'Não existem prazos cadastrados'
  end
end
