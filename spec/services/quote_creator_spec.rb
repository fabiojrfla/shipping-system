require 'rails_helper'

describe QuoteCreator do
  describe '.call' do
    context 'dado um Item e Distância retorna cotações' do
      it 'de Transportadoras cadastradas com seus Preços e Prazos' do
        first_sc = ShippingCompany.create!(registration_number: '12345678000102',
                                           corporate_name: 'Transporte Expresso LTDA', brand_name: 'TExpress',
                                           email: 'contato@texpress.com.br', street_name: 'Avenida Felipe Camarão',
                                           street_number: '100', complement: 'Galpão 10', district: 'Industrial',
                                           city: 'Mossoró', state: 'RN', postal_code: '59000000')
        second_sc = ShippingCompany.create!(registration_number: '98765432000198',
                                            corporate_name: 'Light Transportes LTDA', brand_name: 'TransLight',
                                            email: 'contato@translight.com.br',
                                            street_name: 'Avenida Alberto Maranhão', street_number: '100',
                                            complement: 'Galpão 10', district: 'Centro', city: 'Fortaleza',
                                            state: 'CE', postal_code: '60010010')
        third_sc = ShippingCompany.create!(registration_number: '34567892000189', corporate_name: 'Ache Fretes LTDA',
                                           brand_name: 'Ache', email: 'contato@achefretes.com.br',
                                           street_name: 'Avenida Josefa Medeiros', street_number: '855',
                                           complement: 'Galpão 82', district: 'Centro', city: 'Natal', state: 'RN',
                                           postal_code: '59010000')
        ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.50,
                              shipping_company: first_sc)
        ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.45,
                              shipping_company: second_sc)
        ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.40,
                              shipping_company: third_sc)
        ShippingDeadline.create!(start_distance: 0, end_distance: 500, deadline: 4, shipping_company: first_sc)
        ShippingDeadline.create!(start_distance: 0, end_distance: 500, deadline: 5, shipping_company: second_sc)
        ShippingDeadline.create!(start_distance: 0, end_distance: 500, deadline: 6, shipping_company: third_sc)
        item = Item.create!(sku: 'UGGBBPUR06', height: 70, width: 50, length: 90, weight: 5)
        distance = 250

        quotes = QuoteCreator.call(item, distance)

        expect(quotes.length).to eq 3
      end

      it 'apenas de Transportadoras ativas' do
        first_sc = ShippingCompany.create!(registration_number: '12345678000102',
                                           corporate_name: 'Transporte Expresso LTDA', brand_name: 'TExpress',
                                           email: 'contato@texpress.com.br', street_name: 'Avenida Felipe Camarão',
                                           street_number: '100', complement: 'Galpão 10', district: 'Industrial',
                                           city: 'Mossoró', state: 'RN', postal_code: '59000000')
        second_sc = ShippingCompany.create!(registration_number: '98765432000198',
                                            corporate_name: 'Light Transportes LTDA', brand_name: 'TransLight',
                                            email: 'contato@translight.com.br',
                                            street_name: 'Avenida Alberto Maranhão', street_number: '100',
                                            complement: 'Galpão 10', district: 'Centro', city: 'Fortaleza',
                                            state: 'CE', postal_code: '60010010')
        third_sc = ShippingCompany.create!(registration_number: '34567892000189', corporate_name: 'Ache Fretes LTDA',
                                           brand_name: 'Ache', email: 'contato@achefretes.com.br',
                                           street_name: 'Avenida Josefa Medeiros', street_number: '855',
                                           complement: 'Galpão 82', district: 'Centro', city: 'Natal', state: 'RN',
                                           postal_code: '59010000')
        ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.50,
                              shipping_company: first_sc)
        ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.45,
                              shipping_company: second_sc)
        ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.40,
                              shipping_company: third_sc)
        ShippingDeadline.create!(start_distance: 0, end_distance: 500, deadline: 4, shipping_company: first_sc)
        ShippingDeadline.create!(start_distance: 0, end_distance: 500, deadline: 5, shipping_company: second_sc)
        ShippingDeadline.create!(start_distance: 0, end_distance: 500, deadline: 6, shipping_company: third_sc)
        item = Item.create!(sku: 'UGGBBPUR06', height: 70, width: 50, length: 90, weight: 5)
        distance = 250

        first_sc.inactive!
        quotes = QuoteCreator.call(item, distance)

        expect(quotes.length).to eq 2
      end

      it 'de Transportadoras com preços cadastrados' do
        first_sc = ShippingCompany.create!(registration_number: '12345678000102',
                                           corporate_name: 'Transporte Expresso LTDA', brand_name: 'TExpress',
                                           email: 'contato@texpress.com.br', street_name: 'Avenida Felipe Camarão',
                                           street_number: '100', complement: 'Galpão 10', district: 'Industrial',
                                           city: 'Mossoró', state: 'RN', postal_code: '59000000')
        second_sc = ShippingCompany.create!(registration_number: '98765432000198',
                                            corporate_name: 'Light Transportes LTDA', brand_name: 'TransLight',
                                            email: 'contato@translight.com.br',
                                            street_name: 'Avenida Alberto Maranhão', street_number: '100',
                                            complement: 'Galpão 10', district: 'Centro', city: 'Fortaleza',
                                            state: 'CE', postal_code: '60010010')
        third_sc = ShippingCompany.create!(registration_number: '34567892000189', corporate_name: 'Ache Fretes LTDA',
                                           brand_name: 'Ache', email: 'contato@achefretes.com.br',
                                           street_name: 'Avenida Josefa Medeiros', street_number: '855',
                                           complement: 'Galpão 82', district: 'Centro', city: 'Natal', state: 'RN',
                                           postal_code: '59010000')
        ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.40,
                              shipping_company: third_sc)
        ShippingDeadline.create!(start_distance: 0, end_distance: 500, deadline: 4, shipping_company: first_sc)
        ShippingDeadline.create!(start_distance: 0, end_distance: 500, deadline: 5, shipping_company: second_sc)
        ShippingDeadline.create!(start_distance: 0, end_distance: 500, deadline: 6, shipping_company: third_sc)
        item = Item.create!(sku: 'UGGBBPUR06', height: 70, width: 50, length: 90, weight: 5)
        distance = 250

        quotes = QuoteCreator.call(item, distance)

        expect(quotes.length).to eq 1
      end

      it 'de Transportadoras que atendam as dimensões do Item' do
        first_sc = ShippingCompany.create!(registration_number: '12345678000102',
                                           corporate_name: 'Transporte Expresso LTDA', brand_name: 'TExpress',
                                           email: 'contato@texpress.com.br', street_name: 'Avenida Felipe Camarão',
                                           street_number: '100', complement: 'Galpão 10', district: 'Industrial',
                                           city: 'Mossoró', state: 'RN', postal_code: '59000000')
        second_sc = ShippingCompany.create!(registration_number: '98765432000198',
                                            corporate_name: 'Light Transportes LTDA', brand_name: 'TransLight',
                                            email: 'contato@translight.com.br',
                                            street_name: 'Avenida Alberto Maranhão', street_number: '100',
                                            complement: 'Galpão 10', district: 'Centro', city: 'Fortaleza',
                                            state: 'CE', postal_code: '60010010')
        third_sc = ShippingCompany.create!(registration_number: '34567892000189', corporate_name: 'Ache Fretes LTDA',
                                           brand_name: 'Ache', email: 'contato@achefretes.com.br',
                                           street_name: 'Avenida Josefa Medeiros', street_number: '855',
                                           complement: 'Galpão 82', district: 'Centro', city: 'Natal', state: 'RN',
                                           postal_code: '59010000')
        ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.50,
                              shipping_company: first_sc)
        ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.45,
                              shipping_company: second_sc)
        ShippingPrice.create!(start_volume: 0, end_volume: 0.3, start_weight: 0, end_weight: 10, price_km: 0.30,
                              shipping_company: third_sc)
        ShippingDeadline.create!(start_distance: 0, end_distance: 500, deadline: 4, shipping_company: first_sc)
        ShippingDeadline.create!(start_distance: 0, end_distance: 500, deadline: 5, shipping_company: second_sc)
        ShippingDeadline.create!(start_distance: 0, end_distance: 500, deadline: 6, shipping_company: third_sc)
        item = Item.create!(sku: 'UGGBBPUR06', height: 70, width: 50, length: 90, weight: 5)
        distance = 250

        quotes = QuoteCreator.call(item, distance)

        expect(quotes.length).to eq 2
      end

      it 'de Transportadoras que atendam a Distância de entrega' do
        first_sc = ShippingCompany.create!(registration_number: '12345678000102',
                                           corporate_name: 'Transporte Expresso LTDA', brand_name: 'TExpress',
                                           email: 'contato@texpress.com.br', street_name: 'Avenida Felipe Camarão',
                                           street_number: '100', complement: 'Galpão 10', district: 'Industrial',
                                           city: 'Mossoró', state: 'RN', postal_code: '59000000')
        second_sc = ShippingCompany.create!(registration_number: '98765432000198',
                                            corporate_name: 'Light Transportes LTDA', brand_name: 'TransLight',
                                            email: 'contato@translight.com.br',
                                            street_name: 'Avenida Alberto Maranhão', street_number: '100',
                                            complement: 'Galpão 10', district: 'Centro', city: 'Fortaleza',
                                            state: 'CE', postal_code: '60010010')
        third_sc = ShippingCompany.create!(registration_number: '34567892000189', corporate_name: 'Ache Fretes LTDA',
                                           brand_name: 'Ache', email: 'contato@achefretes.com.br',
                                           street_name: 'Avenida Josefa Medeiros', street_number: '855',
                                           complement: 'Galpão 82', district: 'Centro', city: 'Natal', state: 'RN',
                                           postal_code: '59010000')
        ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.50,
                              shipping_company: first_sc)
        ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.45,
                              shipping_company: second_sc)
        ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.40,
                              shipping_company: third_sc)
        ShippingDeadline.create!(start_distance: 0, end_distance: 200, deadline: 2, shipping_company: first_sc)
        ShippingDeadline.create!(start_distance: 0, end_distance: 500, deadline: 5, shipping_company: second_sc)
        ShippingDeadline.create!(start_distance: 0, end_distance: 150, deadline: 2, shipping_company: third_sc)
        item = Item.create!(sku: 'UGGBBPUR06', height: 70, width: 50, length: 90, weight: 5)
        distance = 250

        quotes = QuoteCreator.call(item, distance)

        expect(quotes.length).to eq 1
      end

      it 'considerando o valor mínimo de acordo com a Distância' do
        first_sc = ShippingCompany.create!(registration_number: '12345678000102',
                                           corporate_name: 'Transporte Expresso LTDA', brand_name: 'TExpress',
                                           email: 'contato@texpress.com.br', street_name: 'Avenida Felipe Camarão',
                                           street_number: '100', complement: 'Galpão 10', district: 'Industrial',
                                           city: 'Mossoró', state: 'RN', postal_code: '59000000')
        ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.50,
                              shipping_company: first_sc)
        MinShippingPrice.create!(start_distance: 0, end_distance: 300, price: 150, shipping_company: first_sc)
        ShippingDeadline.create!(start_distance: 0, end_distance: 500, deadline: 4, shipping_company: first_sc)
        item = Item.create!(sku: 'UGGBBPUR06', height: 70, width: 50, length: 90, weight: 5)
        distance = 250

        quotes = QuoteCreator.call(item, distance)

        expect(quotes.first.price).to eq MinShippingPrice.last.price
        expect(quotes.first.price).to be > ShippingPrice.last.calc_price(distance)
      end

      it 'ordenadas pelo menor Preço' do
        first_sc = ShippingCompany.create!(registration_number: '12345678000102',
                                           corporate_name: 'Transporte Expresso LTDA', brand_name: 'TExpress',
                                           email: 'contato@texpress.com.br', street_name: 'Avenida Felipe Camarão',
                                           street_number: '100', complement: 'Galpão 10', district: 'Industrial',
                                           city: 'Mossoró', state: 'RN', postal_code: '59000000')
        second_sc = ShippingCompany.create!(registration_number: '98765432000198',
                                            corporate_name: 'Light Transportes LTDA', brand_name: 'TransLight',
                                            email: 'contato@translight.com.br',
                                            street_name: 'Avenida Alberto Maranhão', street_number: '100',
                                            complement: 'Galpão 10', district: 'Centro', city: 'Fortaleza',
                                            state: 'CE', postal_code: '60010010')
        third_sc = ShippingCompany.create!(registration_number: '34567892000189', corporate_name: 'Ache Fretes LTDA',
                                           brand_name: 'Ache', email: 'contato@achefretes.com.br',
                                           street_name: 'Avenida Josefa Medeiros', street_number: '855',
                                           complement: 'Galpão 82', district: 'Centro', city: 'Natal', state: 'RN',
                                           postal_code: '59010000')
        ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.45,
                              shipping_company: first_sc)
        ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.50,
                              shipping_company: second_sc)
        ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.40,
                              shipping_company: third_sc)
        ShippingDeadline.create!(start_distance: 0, end_distance: 500, deadline: 4, shipping_company: first_sc)
        ShippingDeadline.create!(start_distance: 0, end_distance: 500, deadline: 5, shipping_company: second_sc)
        ShippingDeadline.create!(start_distance: 0, end_distance: 500, deadline: 6, shipping_company: third_sc)
        item = Item.create!(sku: 'UGGBBPUR06', height: 70, width: 50, length: 90, weight: 5)
        distance = 250

        quotes = QuoteCreator.call(item, distance)

        expect(quotes.first.shipping_company).to eq third_sc
        expect(quotes.last.shipping_company).to eq second_sc
      end

      it 'se houver Transportadoras cadastradas' do
        item = Item.create!(sku: 'UGGBBPUR06', height: 70, width: 50, length: 90, weight: 5)
        distance = 250

        quotes = QuoteCreator.call(item, distance)

        expect(quotes).to be_empty
      end
    end
  end
end
