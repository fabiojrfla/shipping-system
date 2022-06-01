require 'rails_helper'

describe 'Usuário cadastra atualizações de rota' do
  it 'a partir de uma ordem de serviço' do
    sc = ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                                 brand_name: 'TransLight', email: 'contato@translight.com.br', status: 'inactive',
                                 street_name: 'Avenida Alberto Maranhão', street_number: '100',
                                 complement: 'Galpão 10', district: 'Centro', city: 'Fortaleza', state: 'CE',
                                 postal_code: '60010010')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')
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
    so.accepted!

    login_as(user, scope: :user)
    visit user_root_path
    click_on 'Ordens de Serviço'
    click_on so.code
    click_on 'Atualizações de Rota'

    within('h2') do
      expect(page).to have_content 'Atualizações de Rota'
    end
    expect(page).to have_content 'Ordem de Serviço'
    expect(page).to have_select 'Status', options: ['Em trânsito', 'Finalizada']
    expect(page).to have_content 'Nova Atualização de Rota'
    expect(page).to have_select 'Descrição',
                                options: ['Item enviado', 'Item recebido', 'Saiu para entrega', 'Entregue']
    expect(page).to have_field 'Nome da Unidade'
    expect(page).to have_field 'Cidade'
    expect(page).to have_field 'Estado'
  end

  it 'com sucesso' do
    sc = ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                                 brand_name: 'TransLight', email: 'contato@translight.com.br', status: 'inactive',
                                 street_name: 'Avenida Alberto Maranhão', street_number: '100',
                                 complement: 'Galpão 10', district: 'Centro', city: 'Fortaleza', state: 'CE',
                                 postal_code: '60010010')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')
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
    so.accepted!

    login_as(user, scope: :user)
    visit user_root_path
    click_on 'Ordens de Serviço'
    click_on so.code
    click_on 'Atualizações de Rota'

    select 'Em trânsito', from: 'Status'
    select 'Item enviado', from: 'Descrição'
    fill_in 'Nome da Unidade', with: 'Unidade MVF'
    fill_in 'Cidade', with: 'Mossoró'
    fill_in 'Estado', with: 'RN'
    click_on 'Atualizar Ordem de Serviço'

    expect(current_path).to eq service_order_route_updates_path(so)
    expect(page).to have_content 'Rota atualizada com sucesso!'
    within('table') do
      expect(page).to have_content 'Data'
      expect(page).to have_content I18n.l(Time.current.in_time_zone('Brasilia'), format: :short)
      expect(page).to have_content 'Descrição'
      expect(page).to have_content 'Item enviado'
      expect(page).to have_content 'Local'
      expect(page).to have_content 'Unidade MVF'
      expect(page).to have_content 'Cidade'
      expect(page).to have_content 'Mossoró/RN'
    end
  end

  it 'com dados inválidos' do
    sc = ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                                 brand_name: 'TransLight', email: 'contato@translight.com.br', status: 'inactive',
                                 street_name: 'Avenida Alberto Maranhão', street_number: '100',
                                 complement: 'Galpão 10', district: 'Centro', city: 'Fortaleza', state: 'CE',
                                 postal_code: '60010010')
    user = User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')
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
    so.accepted!

    login_as(user, scope: :user)
    visit user_root_path
    click_on 'Ordens de Serviço'
    click_on so.code
    click_on 'Atualizações de Rota'

    select 'Em trânsito', from: 'Status'
    select 'Item enviado', from: 'Descrição'
    fill_in 'Nome da Unidade', with: ''
    fill_in 'Cidade', with: 'Mossoró'
    fill_in 'Estado', with: ''
    click_on 'Atualizar Ordem de Serviço'

    expect(page).to have_content 'Dados inválidos...'
    expect(page).to have_content 'Nome da Unidade não pode ficar em branco'
    expect(page).to have_content 'Estado não pode ficar em branco'
    expect(page).not_to have_content 'Cidade não pode ficar em branco'
    expect(page).to have_field 'Cidade', with: 'Mossoró'
  end
end
