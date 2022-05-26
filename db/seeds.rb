Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br', password: 'whatshisname')

first_sc = ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                   brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                   street_name: 'Avenida Felipe Camarão', street_number: '100',
                                   complement: 'Galpão 10', district: 'Industrial', city: 'Mossoró', state: 'RN',
                                   postal_code: '59000000')
second_sc = ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                                    brand_name: 'TransLight', email: 'contato@translight.com.br', status: 'inactive',
                                    street_name: 'Avenida Alberto Maranhão', street_number: '100',
                                    complement: 'Galpão 10', district: 'Centro', city: 'Mossoró', state: 'RN',
                                    postal_code: '59000000')

User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')

ShippingPrice.create!(start_volume: 0, end_volume: 50, start_weight: 0, end_weight: 10, price_km: 0.50,
                      shipping_company: first_sc)
ShippingPrice.create!(start_volume: 0, end_volume: 50, start_weight: 10, end_weight: 30,
                      price_km: 1, shipping_company: second_sc)
ShippingPrice.create!(start_volume: 50, end_volume: 100, start_weight: 0, end_weight: 10,
                      price_km: 1, shipping_company: first_sc)
ShippingPrice.create!(start_volume: 50, end_volume: 100, start_weight: 10, end_weight: 30,
                      price_km: 2, shipping_company: second_sc)

MinShippingPrice.create!(start_distance: 0, end_distance: 100, price: 100, shipping_company: first_sc)
