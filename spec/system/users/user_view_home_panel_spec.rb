require 'rails_helper'

describe 'Usuário vê painel inicial' do
  it 'com menu de opções' do
    ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                            brand_name: 'TransLight', email: 'contato@translight.com.br',
                            street_name: 'Avenida Alberto Maranhão', street_number: '100', complement: 'Galpão 10',
                            district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000000')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')

    login_as(user, scope: :user)
    visit user_root_path

    expect(page).to have_content 'Painel'
    expect(page).to have_content 'Transportadora: TransLight'
    expect(page).to have_link 'Tabela de Preços'
    expect(page).to have_link 'Tabela de Prazos'
  end

  it 'com status da sua transportadora' do
    ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                            brand_name: 'TransLight', email: 'contato@translight.com.br', status: 'inactive',
                            street_name: 'Avenida Alberto Maranhão', street_number: '100', complement: 'Galpão 10',
                            district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000000')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')

    login_as(user, scope: :user)
    visit user_root_path

    expect(page).to have_content 'Transportadora: TransLight'
    expect(page).to have_content '[Inativa]'
  end
end
