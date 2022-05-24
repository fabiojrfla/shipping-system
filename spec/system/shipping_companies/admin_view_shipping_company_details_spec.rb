require 'rails_helper'

describe 'Administrador vê detalhes de uma transportadora' do
  it 'a partir do painel administrativo' do
    admin = Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br',
                          password: 'whatshisname')
    ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                            brand_name: 'TExpress', email: 'contato@texpress.com.br',
                            street_name: 'Avenida Felipe Camarão', street_number: '100', complement: 'Galpão 10',
                            district: 'Industrial', city: 'Mossoró', state: 'RN', postal_code: '59000000')

    login_as(admin, scope: :admin)
    visit admin_root_path
    click_on 'Transportadoras'
    click_on 'TExpress'

    within('h2') do
      expect(page).to have_content 'Transportadora: TExpress'
    end
    within('h3') do
      expect(page).to have_content 'Transporte Expresso LTDA'
    end
    expect(page).to have_content 'CNPJ: 12345678000102'
    expect(page).to have_content 'Endereço: Avenida Felipe Camarão, 100, Galpão 10, bairro Industrial, Mossoró/RN'
    expect(page).to have_content 'CEP: 59000000'
    expect(page).to have_content 'Email: contato@texpress.com.br'
  end

  it 'e vê botão para alterar status' do
    admin = Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br',
                          password: 'whatshisname')
    ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                            brand_name: 'TExpress', email: 'contato@texpress.com.br',
                            street_name: 'Avenida Felipe Camarão', street_number: '100', complement: 'Galpão 10',
                            district: 'Industrial', city: 'Mossoró', state: 'RN', postal_code: '59000000')

    login_as(admin, scope: :admin)
    visit admin_root_path
    click_on 'Transportadoras'
    click_on 'TExpress'

    expect(page).to have_button 'Desativar Transportadora'
    expect(page).not_to have_button 'Ativar Transportadora'
  end

  it 'e à torna inativa' do
    admin = Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br',
                          password: 'whatshisname')
    ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                            brand_name: 'TExpress', email: 'contato@texpress.com.br',
                            street_name: 'Avenida Felipe Camarão', street_number: '100', complement: 'Galpão 10',
                            district: 'Industrial', city: 'Mossoró', state: 'RN', postal_code: '59000000')
    ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                            brand_name: 'TransLight', email: 'contato@translight.com.br',
                            street_name: 'Avenida Alberto Maranhão', street_number: '100', complement: 'Galpão 10',
                            district: 'Centro', city: 'Fortaleza', state: 'CE', postal_code: '60010010')

    login_as(admin, scope: :admin)
    visit admin_root_path
    click_on 'Transportadoras'
    click_on 'TExpress'
    click_button 'Desativar Transportadora'

    expect(current_path).to eq shipping_companies_path
    within('section#inactive-shipping-companies') do
      expect(page).to have_content '12345678000102'
      expect(page).to have_content 'TExpress'
      expect(page).to have_content 'Mossoró/RN'
    end
    within('section#active-shipping-companies') do
      expect(page).not_to have_content '12345678000102'
      expect(page).not_to have_content 'TExpress'
      expect(page).not_to have_content 'Mossoró/RN'
    end
  end

  it 'e à torna ativa' do
    admin = Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br',
                          password: 'whatshisname')
    ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                            brand_name: 'TExpress', email: 'contato@texpress.com.br', status: 'inactive',
                            street_name: 'Avenida Felipe Camarão', street_number: '100', complement: 'Galpão 10',
                            district: 'Industrial', city: 'Mossoró', state: 'RN', postal_code: '59000000')
    ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                            brand_name: 'TransLight', email: 'contato@translight.com.br', status: 'inactive',
                            street_name: 'Avenida Alberto Maranhão', street_number: '100', complement: 'Galpão 10',
                            district: 'Centro', city: 'Fortaleza', state: 'CE', postal_code: '60010010')

    login_as(admin, scope: :admin)
    visit admin_root_path
    click_on 'Transportadoras'
    click_on 'TExpress'
    click_button 'Ativar Transportadora'

    expect(current_path).to eq shipping_companies_path
    within('section#active-shipping-companies') do
      expect(page).to have_content '12345678000102'
      expect(page).to have_content 'TExpress'
      expect(page).to have_content 'Mossoró/RN'
    end
    within('section#inactive-shipping-companies') do
      expect(page).not_to have_content '12345678000102'
      expect(page).not_to have_content 'TExpress'
      expect(page).not_to have_content 'Mossoró/RN'
    end
  end
end
