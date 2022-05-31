require 'rails_helper'

describe 'Usuário cadastra veículos' do
  it 'com sucesso' do
    ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                            brand_name: 'TransLight', email: 'contato@translight.com.br',
                            street_name: 'Avenida Alberto Maranhão', street_number: '100', complement: 'Galpão 10',
                            district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000000')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')

    login_as(user, scope: :user)
    visit user_root_path
    click_on 'Veículos'
    click_on 'Novo Veículo'
    fill_in 'Placa', with: 'LSN4I49'
    fill_in 'Marca', with: 'Ford'
    fill_in 'Modelo', with: 'F-4000'
    fill_in 'Ano de Fabricação', with: '2002'
    fill_in 'Carga Máxima (kg)', with: '3000'
    click_on 'Criar Veículo'

    expect(current_path).to eq vehicles_path
    expect(page).to have_content 'Veículo cadastrado com sucesso!'
    expect(page).to have_content 'LSN4I49'
    expect(page).to have_content 'Ford'
    expect(page).to have_content 'F-4000'
    expect(page).to have_content '2002'
    expect(page).to have_content '3000kg'
  end

  it 'com dados inválidos' do
    ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                            brand_name: 'TransLight', email: 'contato@translight.com.br',
                            street_name: 'Avenida Alberto Maranhão', street_number: '100', complement: 'Galpão 10',
                            district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000000')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')

    login_as(user, scope: :user)
    visit user_root_path
    click_on 'Veículos'
    click_on 'Novo Veículo'
    fill_in 'Placa', with: ''
    fill_in 'Marca', with: 'Ford'
    fill_in 'Modelo', with: ''
    fill_in 'Ano de Fabricação', with: '2002'
    fill_in 'Carga Máxima (kg)', with: ''
    click_on 'Criar Veículo'

    expect(current_path).to eq vehicles_path
    expect(page).to have_content 'Dados inválidos...'
    expect(page).to have_content 'Placa não pode ficar em branco'
    expect(page).to have_content 'Modelo não pode ficar em branco'
    expect(page).to have_content 'Carga Máxima (kg) não pode ficar em branco'

    expect(page).not_to have_content 'Marca não pode ficar em branco'
    expect(page).not_to have_content 'Ano de Fabricação não pode ficar em branco'

    expect(page).to have_field 'Marca', with: 'Ford'
    expect(page).to have_field 'Ano de Fabricação', with: '2002'
  end
end
