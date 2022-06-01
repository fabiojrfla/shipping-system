require 'rails_helper'

describe 'Visitante consulta status de entrega' do
  it 'a partir da tela inicial' do
    visit root_path
    click_on 'Rastreamento'

    within('h2') do
      expect(page).to have_content 'Rastreamento'
    end
    expect(page).to have_field 'Código de rastreamento'
    expect(page).to have_button 'Rastrear'
  end

  it 'com sucesso' do
    sc = ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                                 brand_name: 'TransLight', email: 'contato@translight.com.br', status: 'inactive',
                                 street_name: 'Avenida Alberto Maranhão', street_number: '100',
                                 complement: 'Galpão 10', district: 'Centro', city: 'Fortaleza', state: 'CE',
                                 postal_code: '60010010')
    item = Item.create!(sku: 'UGGBBPUR06', height: 70, width: 50, length: 90, weight: 5)
    quote = Quote.create!(item:, shipping_company: sc, price: 250, deadline: 4)
    vehicle = Vehicle.create!(license_plate: 'LSN4I49', make: 'Ford', model: 'F-4000', year: '2002', max_load: 3_000,
                              shipping_company: sc)
    so = ServiceOrder.create!(quote:, shipping_company: quote.shipping_company, vehicle:)
    Address.create!(street_name: 'Avenida Rio Branco', street_number: '100', complement: 'Galpão 30',
                    district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000010', addressable: so)
    remittee = Remittee.create!(id_number: '341327200', name: 'Charlie', surname: 'Chaplin', service_order: so)
    Address.create!(street_name: 'Avenida Guararapes', street_number: '100', complement: 'Galpão 88',
                    district: 'Industrial', city: 'Recife', state: 'PE', postal_code: '50010010', addressable: remittee)
    RouteUpdate.create!(description: 'Item enviado', place_name: 'Unidade MVF', city: 'Mossoró', state: 'RN',
                        service_order: so)
    RouteUpdate.create!(description: 'Item recebido', place_name: 'Unidade REC', city: 'Recife', state: 'PE',
                        service_order: so)
    RouteUpdate.create!(description: 'Entregue', place_name: 'Unidade REC', city: 'Recife', state: 'PE',
                        service_order: so)

    visit root_path
    click_on 'Rastreamento'
    fill_in 'Código de rastreamento', with: so.code
    click_on 'Rastrear'

    expect(page).to have_content "Ordem de Serviço: #{so.code}"
    expect(page).to have_content 'Origem: Avenida Rio Branco, 100, Galpão 30, Centro, Mossoró/RN - CEP 59000010'
    expect(page).to have_content 'Destino: Avenida Guararapes, 100, Galpão 88, Industrial, Recife/PE - CEP 50010010'
    expect(page).to have_content 'Transportado por: LSN4I49 - Ford F-4000'
    within('table') do
      expect(page).to have_content 'Item enviado'
      expect(page).to have_content 'Unidade MVF'
      expect(page).to have_content 'Mossoró/RN'
      expect(page).to have_content 'Item recebido'
      expect(page).to have_content 'Unidade REC'
      expect(page).to have_content 'Recife/PE'
      expect(page).to have_content 'Entregue'
    end
  end

  it 'e a ordem de serviço não existe' do
    sc = ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                                 brand_name: 'TransLight', email: 'contato@translight.com.br', status: 'inactive',
                                 street_name: 'Avenida Alberto Maranhão', street_number: '100',
                                 complement: 'Galpão 10', district: 'Centro', city: 'Fortaleza', state: 'CE',
                                 postal_code: '60010010')
    item = Item.create!(sku: 'UGGBBPUR06', height: 70, width: 50, length: 90, weight: 5)
    quote = Quote.create!(item:, shipping_company: sc, price: 250, deadline: 4)
    vehicle = Vehicle.create!(license_plate: 'LSN4I49', make: 'Ford', model: 'F-4000', year: '2002', max_load: 3_000,
                              shipping_company: sc)
    so = ServiceOrder.create!(quote:, shipping_company: quote.shipping_company, vehicle:)
    Address.create!(street_name: 'Avenida Rio Branco', street_number: '100', complement: 'Galpão 30',
                    district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000010', addressable: so)
    remittee = Remittee.create!(id_number: '341327200', name: 'Charlie', surname: 'Chaplin', service_order: so)
    Address.create!(street_name: 'Avenida Guararapes', street_number: '100', complement: 'Galpão 88',
                    district: 'Industrial', city: 'Recife', state: 'PE', postal_code: '50010010', addressable: remittee)
    RouteUpdate.create!(description: 'Item enviado', place_name: 'Unidade MVF', city: 'Mossoró', state: 'RN',
                        service_order: so)
    RouteUpdate.create!(description: 'Item recebido', place_name: 'Unidade REC', city: 'Recife', state: 'PE',
                        service_order: so)
    RouteUpdate.create!(description: 'Entregue', place_name: 'Unidade REC', city: 'Recife', state: 'PE',
                        service_order: so)

    visit root_path
    click_on 'Rastreamento'
    fill_in 'Código de rastreamento', with: 'M1DVBSUWHB2VZSD'
    click_on 'Rastrear'

    expect(page).to have_content 'O código não foi encontrado...'
    expect(page).not_to have_content "Ordem de Serviço: #{so.code}"
    expect(page).not_to have_css 'table'
  end
end
