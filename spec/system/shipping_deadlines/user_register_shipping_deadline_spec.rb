require 'rails_helper'

describe 'Usuário cadastra prazos' do
  it 'com sucesso' do
    ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                            brand_name: 'TransLight', email: 'contato@translight.com.br',
                            street_name: 'Avenida Alberto Maranhão', street_number: '100', complement: 'Galpão 10',
                            district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000000')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')

    login_as(user, scope: :user)
    visit user_root_path
    click_on 'Tabela de Prazos'
    click_on 'Novo Prazo'
    fill_in 'Distância Inicial (km)', with: '0'
    fill_in 'Distância Final (km)', with: '100'
    fill_in 'Dias Úteis', with: '2'
    click_on 'Criar Prazo'

    expect(current_path).to eq shipping_deadlines_path
    expect(page).to have_content 'Prazo cadastrado com sucesso!'
    expect(page).to have_content '0-100km'
    expect(page).to have_content '2 dias úteis'
  end

  it 'com dados inválidos' do
    ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                            brand_name: 'TransLight', email: 'contato@translight.com.br',
                            street_name: 'Avenida Alberto Maranhão', street_number: '100', complement: 'Galpão 10',
                            district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000000')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')

    login_as(user, scope: :user)
    visit user_root_path
    click_on 'Tabela de Prazos'
    click_on 'Novo Prazo'
    fill_in 'Distância Inicial (km)', with: ''
    fill_in 'Distância Final (km)', with: '100'
    fill_in 'Dias Úteis', with: ''
    click_on 'Criar Prazo'

    expect(page).to have_content 'Dados inválidos...'
    expect(page).to have_content 'Distância Inicial (km) não pode ficar em branco'
    expect(page).to have_content 'Dias Úteis não pode ficar em branco'

    expect(page).not_to have_content 'Distância Final (km) não pode ficar em branco'

    expect(page).to have_field 'Distância Final (km)', with: '100'
  end

  it 'com intervalos já contemplados' do
    sc = ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                                 brand_name: 'TransLight', email: 'contato@translight.com.br',
                                 street_name: 'Avenida Alberto Maranhão', street_number: '100', complement: 'Galpão 10',
                                 district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000000')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')
    ShippingDeadline.create!(start_distance: 0, end_distance: 100, deadline: 2, shipping_company: sc)

    login_as(user, scope: :user)
    visit user_root_path
    click_on 'Tabela de Prazos'
    click_on 'Novo Prazo'
    fill_in 'Distância Inicial (km)', with: '50'
    fill_in 'Distância Final (km)', with: '150'
    fill_in 'Dias Úteis', with: '3'
    click_on 'Criar Prazo'

    expect(page).to have_content 'Dados inválidos...'
    expect(page).to have_content 'Distância Inicial (km) já inclusa em intervalo cadastrado'
  end
end
