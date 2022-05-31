require 'rails_helper'

describe 'Administrador vê Ordens de Serviço' do
  it 'com sucesso' do
    admin = Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br',
                          password: 'whatshisname')
    sc = ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                 brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                 street_name: 'Avenida Felipe Camarão', street_number: '100', complement: 'Galpão 10',
                                 district: 'Industrial', city: 'Mossoró', state: 'RN', postal_code: '59000000')
    item = Item.create!(sku: 'UGGBBPUR06', height: 70, width: 50, length: 90, weight: 5)
    first_quote = Quote.create!(item:, shipping_company: sc, price: 250, deadline: 4)
    second_quote = Quote.create!(item:, shipping_company: sc, price: 225, deadline: 5)
    first_so = ServiceOrder.create!(quote: first_quote, shipping_company: first_quote.shipping_company)
    second_so = ServiceOrder.create!(quote: second_quote, shipping_company: second_quote.shipping_company)
    Address.create!(street_name: 'Avenida Rio Branco', street_number: '100', complement: 'Galpão 30',
                    district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000010', addressable: first_so)
    Address.create!(street_name: 'Avenida Guararapes', street_number: '100', complement: 'Galpão 88',
                    district: 'Industrial', city: 'Recife', state: 'PE', postal_code: '50010010',
                    addressable: second_so)
    first_remittee = Remittee.create!(id_number: '341327200', name: 'Charlie', surname: 'Chaplin',
                                      service_order: first_so)
    second_remittee = Remittee.create!(id_number: '71467213101', name: 'Joseph', surname: 'A. Cooper',
                                       service_order: second_so)
    Address.create!(street_name: 'Avenida Guararapes', street_number: '100', complement: 'Galpão 88',
                    district: 'Industrial', city: 'Recife', state: 'PE', postal_code: '50010010',
                    addressable: first_remittee)
    Address.create!(street_name: 'Avenida Rio Branco', street_number: '100', complement: 'Galpão 30',
                    district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000010',
                    addressable: second_remittee)

    login_as(admin, scope: :admin)
    visit admin_root_path
    click_on 'Ordens de Serviço'

    within('h2') do
      expect(page).to have_content 'Ordens de Serviço'
    end
    within('table') do
      expect(page).to have_content 'Data'
      expect(page).to have_content I18n.l(Time.current.to_date)
      expect(page).to have_content 'Código'
      expect(page).to have_link first_so.code
      expect(page).to have_content 'Item'
      expect(page).to have_content 'UGGBBPUR06'
      expect(page).to have_content 'Transportadora'
      expect(page).to have_content 'TExpress'
      expect(page).to have_link second_so.code
    end
    expect(page).not_to have_css 'section#accepted-service-orders'
    expect(page).not_to have_content 'Não existem ordens de serviço criadas'
  end

  it 'e não existem ordens de serviço criadas' do
    admin = Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br',
                          password: 'whatshisname')

    login_as(admin, scope: :admin)
    visit admin_root_path
    click_on 'Ordens de Serviço'

    expect(page).to have_content 'Não existem ordens de serviço criadas'
    expect(page).not_to have_content 'Pendentes'
    expect(page).not_to have_content 'Aceitas'
    expect(page).not_to have_css 'table'
  end
end
