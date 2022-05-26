require 'rails_helper'

RSpec.describe ShippingPrice, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'Volume Inicial deve ser obrigatório' do
        shipping_price = ShippingPrice.new(start_volume: '')
        shipping_price.valid?
        expect(shipping_price.errors.include?(:start_volume)).to eq true
      end

      it 'Volume Final deve ser obrigatório' do
        shipping_price = ShippingPrice.new(end_volume: '')
        shipping_price.valid?
        expect(shipping_price.errors.include?(:end_volume)).to eq true
      end

      it 'Peso Inicial deve ser obrigatório' do
        shipping_price = ShippingPrice.new(start_weight: '')
        shipping_price.valid?
        expect(shipping_price.errors.include?(:start_weight)).to eq true
      end

      it 'Peso Final deve ser obrigatório' do
        shipping_price = ShippingPrice.new(end_weight: '')
        shipping_price.valid?
        expect(shipping_price.errors.include?(:end_weight)).to eq true
      end

      it 'Preço por KM deve ser obrigatório' do
        shipping_price = ShippingPrice.new(price_km: '')
        shipping_price.valid?
        expect(shipping_price.errors.include?(:price_km)).to eq true
      end
    end

    context 'numericality' do
      it 'Volume Inicial deve ser um número inteiro' do
        shipping_price = ShippingPrice.new(start_volume: 0.1)
        shipping_price.valid?
        expect(shipping_price.errors.include?(:start_volume)).to eq true
      end

      it 'Volume Final deve ser um número inteiro' do
        shipping_price = ShippingPrice.new(end_volume: 49.5)
        shipping_price.valid?
        expect(shipping_price.errors.include?(:end_volume)).to eq true
      end
    end

    context 'comparison' do
      it 'Volume Final deve ser maior que Volume Inicial' do
        shipping_price = ShippingPrice.new(start_volume: 10, end_volume: 0)
        shipping_price.valid?
        expect(shipping_price.errors.include?(:end_volume)).to eq true
      end

      it 'Peso Final deve ser maior que Peso Inicial' do
        shipping_price = ShippingPrice.new(start_weight: 50, end_weight: 0)
        shipping_price.valid?
        expect(shipping_price.errors.include?(:end_weight)).to eq true
      end
    end

    context 'register' do
      it 'Intervalo de Volume pode se repetir se for cadastrado um novo intervalo de Peso' do
        sc = ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                     brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                     street_name: 'Avenida Felipe Camarão', street_number: '100',
                                     complement: 'Galpão 10', district: 'Industrial', city: 'Mossoró',
                                     state: 'RN', postal_code: '59000000')
        ShippingPrice.create!(start_volume: 0, end_volume: 50, start_weight: 0, end_weight: 10, price_km: 0.50,
                              shipping_company: sc)
        shipping_price = ShippingPrice.new(start_volume: 0, end_volume: 50, start_weight: 11, end_weight: 20,
                                           price_km: 1, shipping_company: sc)

        expect(shipping_price.valid?).to eq true
      end

      it 'Intervalo de Peso pode se repetir se for cadastrado um novo intervalo de Volume' do
        sc = ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                     brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                     street_name: 'Avenida Felipe Camarão', street_number: '100',
                                     complement: 'Galpão 10', district: 'Industrial', city: 'Mossoró',
                                     state: 'RN', postal_code: '59000000')
        ShippingPrice.create!(start_volume: 0, end_volume: 50, start_weight: 0, end_weight: 10, price_km: 0.50,
                              shipping_company: sc)
        shipping_price = ShippingPrice.new(start_volume: 51, end_volume: 100, start_weight: 0, end_weight: 10,
                                           price_km: 1, shipping_company: sc)

        expect(shipping_price.valid?).to eq true
      end

      it 'Intervalos de Peso e de Volume não podem se repetir em um mesmo cadastro' do
        sc = ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                     brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                     street_name: 'Avenida Felipe Camarão', street_number: '100',
                                     complement: 'Galpão 10', district: 'Industrial', city: 'Mossoró',
                                     state: 'RN', postal_code: '59000000')
        ShippingPrice.create!(start_volume: 0, end_volume: 50, start_weight: 0, end_weight: 10, price_km: 0.50,
                              shipping_company: sc)
        shipping_price = ShippingPrice.new(start_volume: 20, end_volume: 40, start_weight: 3, end_weight: 8,
                                           price_km: 1, shipping_company: sc)

        expect(shipping_price.valid?).to eq false
      end
    end
  end
end
