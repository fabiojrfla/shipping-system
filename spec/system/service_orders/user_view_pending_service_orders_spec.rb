require 'rails_helper'

describe 'Usuário vê Ordens de Serviço pendentes' do
  it 'no painel inicial' do
    sc = ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                                 brand_name: 'TransLight', email: 'contato@translight.com.br', status: 'inactive',
                                 street_name: 'Avenida Alberto Maranhão', street_number: '100',
                                 complement: 'Galpão 10', district: 'Centro', city: 'Fortaleza', state: 'CE',
                                 postal_code: '60010010')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')
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

    login_as(user, scope: :user)
    visit user_root_path

    within('h3') do
      expect(page).to have_content 'Ordens de Serviço pendentes'
    end
    within('table') do
      expect(page).to have_content 'Data'
      expect(page).to have_content I18n.l(Time.current.to_date)
      expect(page).to have_content 'Código'
      expect(page).to have_link first_so.code
      expect(page).to have_content 'Item'
      expect(page).to have_content 'UGGBBPUR06'
      expect(page).to have_content 'Transportadora'
      expect(page).to have_content 'TransLight'
      expect(page).to have_link second_so.code
    end
    expect(page).not_to have_content 'Não há ordens de serviço pendentes'
  end

  it 'e não há Ordens de Serviço pendentes' do
    ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                                 brand_name: 'TransLight', email: 'contato@translight.com.br', status: 'inactive',
                                 street_name: 'Avenida Alberto Maranhão', street_number: '100',
                                 complement: 'Galpão 10', district: 'Centro', city: 'Fortaleza', state: 'CE',
                                 postal_code: '60010010')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')

    login_as(user, scope: :user)
    visit user_root_path

    expect(page).to have_content 'Não há ordens de serviço pendentes'
    expect(page).not_to have_css 'table'
  end
end
