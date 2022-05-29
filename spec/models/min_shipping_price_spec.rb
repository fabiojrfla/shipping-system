require 'rails_helper'

RSpec.describe MinShippingPrice, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'Distância Inicial deve ser obrigatório' do
        min_shipping_price = MinShippingPrice.new(start_distance: '')
        min_shipping_price.valid?
        expect(min_shipping_price.errors.include?(:start_distance)).to eq true
      end

      it 'Distância Final deve ser obrigatório' do
        min_shipping_price = MinShippingPrice.new(end_distance: '')
        min_shipping_price.valid?
        expect(min_shipping_price.errors.include?(:end_distance)).to eq true
      end

      it 'Preço deve ser obrigatório' do
        min_shipping_price = MinShippingPrice.new(price: '')
        min_shipping_price.valid?
        expect(min_shipping_price.errors.include?(:price)).to eq true
      end
    end

    context 'numericality' do
      it 'Distância Inicial deve ser um número inteiro' do
        min_shipping_price = MinShippingPrice.new(start_distance: 1.5)
        min_shipping_price.valid?
        expect(min_shipping_price.errors.include?(:start_distance)).to eq true
      end

      it 'Distância Final deve ser um número inteiro' do
        min_shipping_price = MinShippingPrice.new(end_distance: 78.5)
        min_shipping_price.valid?
        expect(min_shipping_price.errors.include?(:end_distance)).to eq true
      end
    end

    context 'comparison' do
      it 'Distância Final deve ser maior que Distância Inicial' do
        min_shipping_price = MinShippingPrice.new(start_distance: 200, end_distance: 100)
        min_shipping_price.valid?
        expect(min_shipping_price.errors.include?(:end_distance)).to eq true
      end
    end

    context 'register' do
      it 'se intervalo de Distância for diferente dos já cadastrados' do
        sc = ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                     brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                     street_name: 'Avenida Felipe Camarão', street_number: '100',
                                     complement: 'Galpão 10', district: 'Industrial', city: 'Mossoró',
                                     state: 'RN', postal_code: '59000000')
        MinShippingPrice.create!(start_distance: 0, end_distance: 100, price: 100, shipping_company: sc)
        min_shipping_price = MinShippingPrice.new(start_distance: 100, end_distance: 200, price: 150,
                                                  shipping_company: sc)

        expect(min_shipping_price.valid?).to eq true
      end

      it 'Distância Inicial não pode estar inclusa em intervalos já cadastrados' do
        sc = ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                     brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                     street_name: 'Avenida Felipe Camarão', street_number: '100',
                                     complement: 'Galpão 10', district: 'Industrial', city: 'Mossoró',
                                     state: 'RN', postal_code: '59000000')
        MinShippingPrice.create!(start_distance: 0, end_distance: 100, price: 100, shipping_company: sc)
        min_shipping_price = MinShippingPrice.new(start_distance: 50, end_distance: 150, price: 150,
                                                  shipping_company: sc)

        expect(min_shipping_price.valid?).to eq false
      end

      it 'Distância Final não pode estar inclusa em intervalos já cadastrados' do
        sc = ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                     brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                     street_name: 'Avenida Felipe Camarão', street_number: '100',
                                     complement: 'Galpão 10', district: 'Industrial', city: 'Mossoró',
                                     state: 'RN', postal_code: '59000000')
        MinShippingPrice.create!(start_distance: 100, end_distance: 200, price: 150, shipping_company: sc)
        min_shipping_price = MinShippingPrice.new(start_distance: 0, end_distance: 150, price: 100,
                                                  shipping_company: sc)

        expect(min_shipping_price.valid?).to eq false
      end
    end
  end
end
