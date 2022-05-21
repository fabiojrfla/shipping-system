require 'rails_helper'

describe 'Administrador vê transportadoras' do
  it 'com sucesso' do
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

    within 'h2' do
      expect(page).to have_content 'Transportadoras'
    end
    expect(page).not_to have_content 'Não existem transportadoras cadastrados'

    within 'table' do
      expect(page).to have_content '12345678000102'
      expect(page).to have_content 'TExpress'
      expect(page).to have_content 'Mossoró/RN'
      expect(page).to have_content '98765432000198'
      expect(page).to have_content 'TransLight'
      expect(page).to have_content 'Fortaleza/CE'
    end
  end
end
