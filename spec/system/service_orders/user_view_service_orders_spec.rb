require 'rails_helper'

describe 'Usuário vê Ordens de Serviço' do
  it 'da sua transportadora' do
    first_sc = ShippingCompany.create!(registration_number: '98765432000198',
                                       corporate_name: 'Light Transportes LTDA', brand_name: 'TransLight',
                                       email: 'contato@translight.com.br', street_name: 'Avenida Alberto Maranhão',
                                       street_number: '100', complement: 'Galpão 10', district: 'Centro',
                                       city: 'Fortaleza', state: 'CE', postal_code: '60010010')
    second_sc = ShippingCompany.create!(registration_number: '12345678000102',
                                        corporate_name: 'Transporte Expresso LTDA', brand_name: 'TExpress',
                                        email: 'contato@texpress.com.br', street_name: 'Avenida Felipe Camarão',
                                        street_number: '100', complement: 'Galpão 10', district: 'Industrial',
                                        city: 'Mossoró', state: 'RN', postal_code: '59000000')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')
    first_item = Item.create!(sku: 'UGGBBPUR06', height: 60, width: 60, length: 80, weight: 4)
    second_item = Item.create!(sku: 'BFGBBPUR08', height: 70, width: 50, length: 90, weight: 5)
    first_quote = Quote.create!(item: first_item, shipping_company: first_sc, price: 250, deadline: 4)
    second_quote = Quote.create!(item: first_item, shipping_company: first_sc, price: 225, deadline: 5)
    third_quote = Quote.create!(item: second_item, shipping_company: second_sc, price: 200, deadline: 3)
    first_so = ServiceOrder.create!(quote: first_quote, shipping_company: first_quote.shipping_company)
    second_so = ServiceOrder.create!(quote: second_quote, shipping_company: second_quote.shipping_company)
    third_so = ServiceOrder.create!(quote: third_quote, shipping_company: third_quote.shipping_company)
    Address.create!(street_name: 'Avenida Rio Branco', street_number: '100', complement: 'Galpão 30',
                    district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000010', addressable: first_so)
    Address.create!(street_name: 'Avenida Rio Branco', street_number: '100', complement: 'Galpão 30',
                    district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000010', addressable: third_so)
    Address.create!(street_name: 'Avenida Guararapes', street_number: '100', complement: 'Galpão 88',
                    district: 'Industrial', city: 'Recife', state: 'PE', postal_code: '50010010',
                    addressable: second_so)
    first_remittee = Remittee.create!(id_number: '341327200', name: 'Charlie', surname: 'Chaplin',
                                      service_order: first_so)
    second_remittee = Remittee.create!(id_number: '71467213101', name: 'Joseph', surname: 'A. Cooper',
                                       service_order: second_so)
    third_remittee = Remittee.create!(id_number: '123456789', name: 'Jesse', surname: 'Pinkman',
                                      service_order: third_so)
    Address.create!(street_name: 'Avenida Guararapes', street_number: '100', complement: 'Galpão 88',
                    district: 'Industrial', city: 'Recife', state: 'PE', postal_code: '50010010',
                    addressable: first_remittee)
    Address.create!(street_name: 'Avenida Rio Branco', street_number: '100', complement: 'Galpão 30',
                    district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000010',
                    addressable: second_remittee)
    Address.create!(street_name: 'Avenida Guararapes', street_number: '100', complement: 'Galpão 88',
                    district: 'Industrial', city: 'Recife', state: 'PE', postal_code: '50010010',
                    addressable: third_remittee)

    login_as(user, scope: :user)
    visit user_root_path
    click_on 'Ordens de Serviço'

    expect(page).to have_content 'Ordens de Serviço'
    expect(page).to have_content 'Data'
    expect(page).to have_content I18n.l(Time.current.to_date)
    expect(page).to have_content 'Código'
    expect(page).to have_link first_so.code
    expect(page).to have_content 'Item'
    expect(page).to have_content 'UGGBBPUR06'
    expect(page).to have_link second_so.code

    expect(page).not_to have_content third_so.code
    expect(page).not_to have_content 'BFGBBPUR08'
    expect(page).not_to have_content 'Transportadora'
    expect(page).not_to have_content 'TransLight'
    expect(page).not_to have_content 'TExpress'
    expect(page).not_to have_css 'section#accepted-service-orders'
    expect(page).not_to have_content 'Nenhuma ordem de serviço'
  end

  it 'e não há nenhuma ordem de serviço' do
    ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                            brand_name: 'TransLight', email: 'contato@translight.com.br',
                            street_name: 'Avenida Alberto Maranhão', street_number: '100', complement: 'Galpão 10',
                            district: 'Centro', city: 'Fortaleza', state: 'CE', postal_code: '60010010')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')

    login_as(user, scope: :user)
    visit user_root_path
    click_on 'Ordens de Serviço'

    expect(page).to have_content 'Nenhuma ordem de serviço'
    expect(page).not_to have_content 'Não existem ordens de serviço criadas'
    expect(page).not_to have_content 'Pendentes'
    expect(page).not_to have_content 'Aceitas'
    expect(page).not_to have_content 'Rejeitadas'
    expect(page).not_to have_css 'table'
  end
end
