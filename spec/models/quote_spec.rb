require 'rails_helper'

RSpec.describe Quote, type: :model do
  describe '#valid?' do
    it 'Preço deve ser obrigatório' do
      quote = Quote.new(price: '')
      quote.valid?
      expect(quote.errors.include?(:price)).to eq true
    end

    it 'Prazo deve ser obrigatório' do
      quote = Quote.new(deadline: '')
      quote.valid?
      expect(quote.errors.include?(:deadline)).to eq true
    end

    it 'Prazo deve ser um número inteiro' do
      quote = Quote.new(deadline: 1.5)
      quote.valid?
      expect(quote.errors.include?(:deadline)).to eq true
    end
  end

  describe 'gera um código aleátorio' do
    it 'ao gerar uma nova cotação' do
      sc = ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                   brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                   street_name: 'Avenida Felipe Camarão', street_number: '100',
                                   complement: 'Galpão 10', district: 'Industrial', city: 'Mossoró', state: 'RN',
                                   postal_code: '59000000')
      item = Item.create!(sku: 'UGGBBPUR06', height: 70, width: 50, length: 90, weight: 5)
      quote = Quote.new(item:, shipping_company: sc, price: 250, deadline: 4)

      quote.save!
      result = quote.code

      expect(result).not_to be_empty
      expect(result.length).to eq 12
    end

    it 'e o código é único' do
      sc = ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                   brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                   street_name: 'Avenida Felipe Camarão', street_number: '100',
                                   complement: 'Galpão 10', district: 'Industrial', city: 'Mossoró', state: 'RN',
                                   postal_code: '59000000')
      item = Item.create!(sku: 'UGGBBPUR06', height: 70, width: 50, length: 90, weight: 5)
      first_quote = Quote.create!(item:, shipping_company: sc, price: 250, deadline: 4)
      second_quote = Quote.new(item:, shipping_company: sc, price: 225, deadline: 5)

      second_quote.save!

      expect(second_quote.code).not_to eq first_quote.code
    end
  end
end
