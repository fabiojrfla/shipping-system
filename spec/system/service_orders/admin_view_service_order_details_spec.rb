require 'rails_helper'

describe 'Administrador vê detalhes de uma Ordem de Serviço' do
  it 'a partir do painel administrativo' do
    admin = Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br',
                          password: 'whatshisname')
    sc = ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                 brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                 street_name: 'Avenida Felipe Camarão', street_number: '100', complement: 'Galpão 10',
                                 district: 'Industrial', city: 'Mossoró', state: 'RN', postal_code: '59000000')
    item = Item.create!(sku: 'UGGBBPUR06', height: 70, width: 50, length: 90, weight: 5)
    quote = Quote.create!(item:, shipping_company: sc, price: 250, deadline: 4)
    so = ServiceOrder.create!(quote:, shipping_company: quote.shipping_company)
    Address.create!(street_name: 'Avenida Rio Branco', street_number: '100', complement: 'Galpão 30',
                    district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000010', addressable: so)
    remittee = Remittee.create!(id_number: '341327200', name: 'Charlie', surname: 'Chaplin', service_order: so)
    Address.create!(street_name: 'Avenida Guararapes', street_number: '100', complement: 'Galpão 88',
                    district: 'Industrial', city: 'Recife', state: 'PE', postal_code: '50010010',addressable: remittee)

    login_as(admin, scope: :admin)
    visit admin_root_path
    click_on 'Ordens de Serviço'
    click_on so.code

    within('h2') do
      expect(page).to have_content "Ordem de Serviço #{so.code}"
    end
    expect(page).to have_content '[Pendente]'
    expect(page).to have_content 'Data'
    expect(page).to have_content I18n.l(Time.current.to_date)
    expect(page).to have_content 'Transportadora'
    expect(page).to have_content '12345678000102 - Transporte Expresso LTDA'
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
  end

  it 'e volta pra tela de ordens de serviços' do
    admin = Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br',
                          password: 'whatshisname')
    sc = ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                 brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                 street_name: 'Avenida Felipe Camarão', street_number: '100', complement: 'Galpão 10',
                                 district: 'Industrial', city: 'Mossoró', state: 'RN', postal_code: '59000000')
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

    login_as(admin, scope: :admin)
    visit admin_root_path
    click_on 'Ordens de Serviço'
    click_on so.code
    click_on 'Voltar'

    expect(current_path).to eq service_orders_path
  end
end
