require 'rails_helper'

RSpec.describe ServiceOrder, type: :model do
  describe 'status' do
    it 'pendente quando criada' do
      sc = ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                   brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                   street_name: 'Avenida Felipe Camarão', street_number: '100',
                                   complement: 'Galpão 10', district: 'Industrial', city: 'Mossoró', state: 'RN',
                                   postal_code: '59000000')
      item = Item.create!(sku: 'UGGBBPUR06', height: 70, width: 50, length: 90, weight: 5)
      quote = Quote.create!(item:, shipping_company: sc, price: 250, deadline: 4)
      service_order = ServiceOrder.create!(quote:)

      expect(service_order.pending?).to eq true
    end

    it 'deve mudar para aceita' do
      sc = ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                   brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                   street_name: 'Avenida Felipe Camarão', street_number: '100',
                                   complement: 'Galpão 10', district: 'Industrial', city: 'Mossoró', state: 'RN',
                                   postal_code: '59000000')
      item = Item.create!(sku: 'UGGBBPUR06', height: 70, width: 50, length: 90, weight: 5)
      quote = Quote.create!(item:, shipping_company: sc, price: 250, deadline: 4)
      service_order = ServiceOrder.create!(quote:)

      service_order.accepted!

      expect(service_order.accepted?).to eq true
    end
  end

  describe 'gera um código aleátorio' do
    it 'ao gerar uma nova Ordem de Serviço' do
      sc = ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                   brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                   street_name: 'Avenida Felipe Camarão', street_number: '100',
                                   complement: 'Galpão 10', district: 'Industrial', city: 'Mossoró', state: 'RN',
                                   postal_code: '59000000')
      item = Item.create!(sku: 'UGGBBPUR06', height: 70, width: 50, length: 90, weight: 5)
      quote = Quote.create!(item:, shipping_company: sc, price: 250, deadline: 4)
      service_order = ServiceOrder.new(quote:)

      service_order.save!
      result = service_order.code

      expect(result).not_to be_empty
      expect(result.length).to eq 15
    end

    it 'e o código é único' do
      sc = ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                   brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                   street_name: 'Avenida Felipe Camarão', street_number: '100',
                                   complement: 'Galpão 10', district: 'Industrial', city: 'Mossoró', state: 'RN',
                                   postal_code: '59000000')
      item = Item.create!(sku: 'UGGBBPUR06', height: 70, width: 50, length: 90, weight: 5)
      first_quote = Quote.create!(item:, shipping_company: sc, price: 250, deadline: 4)
      second_quote = Quote.create!(item:, shipping_company: sc, price: 225, deadline: 5)
      first_service_order = ServiceOrder.create!(quote: first_quote)
      second_service_order = ServiceOrder.new(quote: second_quote)

      second_service_order.save!

      expect(second_service_order.code).not_to eq first_service_order.code
    end
  end
end
