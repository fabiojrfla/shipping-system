require 'rails_helper'

RSpec.describe ShippingDeadline, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'Distância Inicial deve ser obrigatório' do
        shipping_deadline = ShippingDeadline.new(start_distance: '')
        shipping_deadline.valid?
        expect(shipping_deadline.errors.include?(:start_distance)).to eq true
      end

      it 'Distância Final deve ser obrigatório' do
        shipping_deadline = ShippingDeadline.new(end_distance: '')
        shipping_deadline.valid?
        expect(shipping_deadline.errors.include?(:end_distance)).to eq true
      end

      it 'Preço deve ser obrigatório' do
        shipping_deadline = ShippingDeadline.new(deadline: '')
        shipping_deadline.valid?
        expect(shipping_deadline.errors.include?(:deadline)).to eq true
      end
    end

    context 'numericality' do
      it 'Distância Inicial deve ser um número inteiro' do
        shipping_deadline = ShippingDeadline.new(start_distance: 1.5)
        shipping_deadline.valid?
        expect(shipping_deadline.errors.include?(:start_distance)).to eq true
      end

      it 'Distância Final deve ser um número inteiro' do
        shipping_deadline = ShippingDeadline.new(end_distance: 78.5)
        shipping_deadline.valid?
        expect(shipping_deadline.errors.include?(:end_distance)).to eq true
      end
    end

    context 'comparison' do
      it 'Distância Final deve ser maior que Distância Inicial' do
        shipping_deadline = ShippingDeadline.new(start_distance: 200, end_distance: 100)
        shipping_deadline.valid?
        expect(shipping_deadline.errors.include?(:end_distance)).to eq true
      end
    end

    context 'register' do
      it 'intervalo de Distância precisa ser diferente dos já cadastrados' do
        sc = ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                     brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                     street_name: 'Avenida Felipe Camarão', street_number: '100',
                                     complement: 'Galpão 10', district: 'Industrial', city: 'Mossoró',
                                     state: 'RN', postal_code: '59000000')
        ShippingDeadline.create!(start_distance: 0, end_distance: 100, deadline: 100, shipping_company: sc)
        shipping_deadline = ShippingDeadline.new(start_distance: 100, end_distance: 200, deadline: 150,
                                                  shipping_company: sc)

        expect(shipping_deadline.valid?).to eq true
      end

      it 'Distância Inicial não pode estar inclusa em intervalos já cadastrados' do
        sc = ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                     brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                     street_name: 'Avenida Felipe Camarão', street_number: '100',
                                     complement: 'Galpão 10', district: 'Industrial', city: 'Mossoró',
                                     state: 'RN', postal_code: '59000000')
        ShippingDeadline.create!(start_distance: 0, end_distance: 100, deadline: 2, shipping_company: sc)
        shipping_deadline = ShippingDeadline.new(start_distance: 50, end_distance: 150, deadline: 3,
                                                  shipping_company: sc)

        expect(shipping_deadline.valid?).to eq false
      end

      it 'Distância Final não pode estar inclusa em intervalos já cadastrados' do
        sc = ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                     brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                     street_name: 'Avenida Felipe Camarão', street_number: '100',
                                     complement: 'Galpão 10', district: 'Industrial', city: 'Mossoró',
                                     state: 'RN', postal_code: '59000000')
        ShippingDeadline.create!(start_distance: 100, end_distance: 200, deadline: 4, shipping_company: sc)
        shipping_deadline = ShippingDeadline.new(start_distance: 0, end_distance: 150, deadline: 3,
                                                  shipping_company: sc)

        expect(shipping_deadline.valid?).to eq false
      end
    end
  end
end
