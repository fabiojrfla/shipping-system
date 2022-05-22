require 'rails_helper'

RSpec.describe ShippingCompany, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'CNPJ deve ser obrigatório' do
        shipping_company = ShippingCompany.new(registration_number: '')
        shipping_company.valid?
        expect(shipping_company.errors.include?(:registration_number)).to eq true
      end

      it 'Razão Social deve ser obrigatório' do
        shipping_company = ShippingCompany.new(corporate_name: '')
        shipping_company.valid?
        expect(shipping_company.errors.include?(:corporate_name)).to eq true
      end

      it 'Nome Fantasia deve ser obrigatório' do
        shipping_company = ShippingCompany.new(brand_name: '')
        shipping_company.valid?
        expect(shipping_company.errors.include?(:brand_name)).to eq true
      end

      it 'E-mail deve ser obrigatório' do
        shipping_company = ShippingCompany.new(email: '')
        shipping_company.valid?
        expect(shipping_company.errors.include?(:email)).to eq true
      end

      it 'Logradouro deve ser obrigatório' do
        shipping_company = ShippingCompany.new(street_name: '')
        shipping_company.valid?
        expect(shipping_company.errors.include?(:street_name)).to eq true
      end

      it 'Número do endereço deve ser obrigatório' do
        shipping_company = ShippingCompany.new(street_number: '')
        shipping_company.valid?
        expect(shipping_company.errors.include?(:street_number)).to eq true
      end

      it 'Bairro deve ser obrigatório' do
        shipping_company = ShippingCompany.new(district: '')
        shipping_company.valid?
        expect(shipping_company.errors.include?(:district)).to eq true
      end

      it 'Cidade deve ser obrigatório' do
        shipping_company = ShippingCompany.new(city: '')
        shipping_company.valid?
        expect(shipping_company.errors.include?(:city)).to eq true
      end

      it 'Estado deve ser obrigatório' do
        shipping_company = ShippingCompany.new(state: '')
        shipping_company.valid?
        expect(shipping_company.errors.include?(:state)).to eq true
      end

      it 'CEP deve ser obrigatório' do
        shipping_company = ShippingCompany.new(postal_code: '')
        shipping_company.valid?
        expect(shipping_company.errors.include?(:postal_code)).to eq true
      end
    end

    context 'uniqueness' do
      it 'CNPJ deve ser único' do
        ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                street_name: 'Avenida Felipe Camarão', street_number: '100', complement: 'Galpão 10',
                                district: 'Industrial', city: 'Mossoró', state: 'RN', postal_code: '59000000')
        shipping_company = ShippingCompany.new(registration_number: '12345678000102')
        shipping_company.valid?
        expect(shipping_company.errors.include?(:registration_number)).to eq true
      end

      it 'E-mail deve ser único' do
        ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                street_name: 'Avenida Felipe Camarão', street_number: '100', complement: 'Galpão 10',
                                district: 'Industrial', city: 'Mossoró', state: 'RN', postal_code: '59000000')
        shipping_company = ShippingCompany.new(email: 'contato@texpress.com.br')
        shipping_company.valid?
        expect(shipping_company.errors.include?(:email)).to eq true
      end
    end

    context 'format' do
      it 'CNPJ deve ter formato válido' do
        shipping_company = ShippingCompany.new(registration_number: '12.345.678/0001-02')
        shipping_company.valid?
        expect(shipping_company.errors.include?(:registration_number)).to eq true
      end

      it 'Estado deve ter formato válido' do
        shipping_company = ShippingCompany.new(state: '84')
        shipping_company.valid?
        expect(shipping_company.errors.include?(:state)).to eq true
      end

      it 'CEP deve ter formato válido' do
        first_shipping_company = ShippingCompany.new(postal_code: '59000-000')
        second_shipping_company = ShippingCompany.new(postal_code: '590a00z0')

        first_shipping_company.valid?
        second_shipping_company.valid?

        expect(first_shipping_company.errors.include?(:postal_code)).to eq true
        expect(second_shipping_company.errors.include?(:postal_code)).to eq true
      end
    end

    context 'length' do
      it 'CNPJ deve ter tamanho válido' do
        first_shipping_company = ShippingCompany.new(registration_number: '123456780000102')
        second_shipping_company = ShippingCompany.new(registration_number: '1234567800012')

        first_shipping_company.valid?
        second_shipping_company.valid?

        expect(first_shipping_company.errors.include?(:registration_number)).to eq true
        expect(second_shipping_company.errors.include?(:registration_number)).to eq true
      end

      it 'Estado deve ter tamanho válido' do
        shipping_company = ShippingCompany.new(state: 'Rio Grande do Norte')
        shipping_company.valid?
        expect(shipping_company.errors.include?(:state)).to eq true
      end

      it 'CEP deve ter tamanho válido' do
        first_shipping_company = ShippingCompany.new(postal_code: '590000001')
        second_shipping_company = ShippingCompany.new(postal_code: '5900000')

        first_shipping_company.valid?
        second_shipping_company.valid?

        expect(first_shipping_company.errors.include?(:postal_code)).to eq true
        expect(second_shipping_company.errors.include?(:postal_code)).to eq true
      end
    end
  end
end