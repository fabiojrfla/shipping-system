require 'rails_helper'

describe 'Usuário vê detalhes de uma Ordem de Serviço' do
  it 'a partir do painel inicial' do
    sc = ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                                 brand_name: 'TransLight', email: 'contato@translight.com.br', status: 'inactive',
                                 street_name: 'Avenida Alberto Maranhão', street_number: '100',
                                 complement: 'Galpão 10', district: 'Centro', city: 'Fortaleza', state: 'CE',
                                 postal_code: '60010010')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')
    item = Item.create!(sku: 'UGGBBPUR06', height: 70, width: 50, length: 90, weight: 5)
    quote = Quote.create!(item:, shipping_company: sc, price: 250, deadline: 4)
    so = ServiceOrder.create!(quote:, shipping_company: quote.shipping_company)
    Address.create!(street_name: 'Avenida Rio Branco', street_number: '100', complement: 'Galpão 30',
                    district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000010', addressable: so)
    remittee = Remittee.create!(id_number: '341327200', name: 'Charlie', surname: 'Chaplin', service_order: so)
    Address.create!(street_name: 'Avenida Guararapes', street_number: '100', complement: 'Galpão 88',
                    district: 'Industrial', city: 'Recife', state: 'PE', postal_code: '50010010', addressable: remittee)

    login_as(user, scope: :user)
    visit user_root_path
    click_on 'Ordens de Serviço'
    click_on so.code

    within('h2') do
      expect(page).to have_content "Ordem de Serviço #{so.code}"
    end
    expect(page).to have_content '[Pendente]'
    expect(page).to have_content 'Data'
    expect(page).to have_content I18n.l(Time.current.to_date)
    within('div#item') do
      expect(page).to have_content 'Item UGGBBPUR06'
      expect(page).to have_content 'Dimensões: 70 x 50 x 90cm'
      expect(page).to have_content 'Peso: 5kg'
    end
    expect(page).to have_content 'Endereço para retirada:'
    expect(page).to have_content 'Avenida Rio Branco, 100, Galpão 30, Centro, Mossoró/RN - CEP 59000010'
    within('div#remittee') do
      expect(page).to have_content 'Destinatário'
      expect(page).to have_content 'Doc. de Identificação: 341327200'
      expect(page).to have_content 'Nome Completo: Charlie Chaplin'
    end
    expect(page).to have_content 'Endereço para entrega:'
    expect(page).to have_content 'Avenida Guararapes, 100, Galpão 88, Industrial, Recife/PE - CEP 50010010'
    expect(page).to have_content 'Valor do frete: R$ 250,00'
    expect(page).to have_content 'Estimativa de entrega: 4 dias úteis'
    expect(page).to have_link 'Aceitar Ordem de Serviço'
    expect(page).to have_button 'Rejeitar Ordem de Serviço'

    expect(page).not_to have_content 'Transportadora'
    expect(page).not_to have_content '12345678000102 - Transporte Expresso LTDA'
  end

  it 'e a aceita' do
    sc = ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                                 brand_name: 'TransLight', email: 'contato@translight.com.br',
                                 street_name: 'Avenida Alberto Maranhão', street_number: '100',
                                 complement: 'Galpão 10', district: 'Centro', city: 'Fortaleza', state: 'CE',
                                 postal_code: '60010010')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')
    first_item = Item.create!(sku: 'UGGBBPUR06', height: 60, width: 60, length: 80, weight: 4)
    second_item = Item.create!(sku: 'BFGBBPUR08', height: 70, width: 50, length: 90, weight: 5)
    first_quote = Quote.create!(item: first_item, shipping_company: sc, price: 250, deadline: 4)
    second_quote = Quote.create!(item: second_item, shipping_company: sc, price: 225, deadline: 5)
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
    Vehicle.create!(license_plate: 'LSN4I49', make: 'Ford', model: 'F-4000', year: '2002', max_load: 3_000,
                    shipping_company: sc)
    Vehicle.create!(license_plate: 'BEE4R22', make: 'Fiat', model: 'Fiorino', year: '2012', max_load: 600,
                    shipping_company: sc)

    login_as(user, scope: :user)
    visit user_root_path
    click_on 'Ordens de Serviço'
    click_on second_so.code
    click_on 'Aceitar Ordem de Serviço'
    select 'BEE4R22 - Fiat Fiorino', from: 'Veículo'
    click_on 'Atualizar Ordem de Serviço'

    expect(current_path).to eq service_order_path(second_so)
    expect(page).to have_content 'Ordem de Serviço aceita!'
    expect(page).to have_content 'Veículo responsável pela entrega: BEE4R22 - Fiat Fiorino'
    expect(page).not_to have_content '[Pendente]'
  end

  it 'e volta pra tela de ordens de serviços' do
    sc = ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                                 brand_name: 'TransLight', email: 'contato@translight.com.br', status: 'inactive',
                                 street_name: 'Avenida Alberto Maranhão', street_number: '100',
                                 complement: 'Galpão 10', district: 'Centro', city: 'Fortaleza', state: 'CE',
                                 postal_code: '60010010')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')
    item = Item.create!(sku: 'UGGBBPUR06', height: 70, width: 50, length: 90, weight: 5)
    quote = Quote.create!(item:, shipping_company: sc, price: 250, deadline: 4)
    so = ServiceOrder.create!(quote:, shipping_company: quote.shipping_company)
    Address.create!(street_name: 'Avenida Rio Branco', street_number: '100', complement: 'Galpão 30',
                    district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000010',
                    addressable: so)
    remittee = Remittee.create!(id_number: '341327200', name: 'Charlie', surname: 'Chaplin', service_order: so)
    Address.create!(street_name: 'Avenida Guararapes', street_number: '100', complement: 'Galpão 88',
                    district: 'Industrial', city: 'Recife', state: 'PE', postal_code: '50010010',
                    addressable: remittee)

    login_as(user, scope: :user)
    visit user_root_path
    click_on 'Ordens de Serviço'
    click_on so.code
    click_on 'Voltar'

    expect(current_path).to eq service_orders_path
  end
end
