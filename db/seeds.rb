Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br', password: 'whatshisname')

first_sc = ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                   brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                   street_name: 'Avenida Felipe Camarão', street_number: '100',
                                   complement: 'Galpão 10', district: 'Industrial', city: 'Mossoró', state: 'RN',
                                   postal_code: '59000000')
second_sc = ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                                    brand_name: 'TransLight', email: 'contato@translight.com.br', status: 'inactive',
                                    street_name: 'Avenida Alberto Maranhão', street_number: '100',
                                    complement: 'Galpão 10', district: 'Centro', city: 'Fortaleza', state: 'CE',
                                    postal_code: '60010010')
third_sc = ShippingCompany.create!(registration_number: '34567892000189', corporate_name: 'Ache Fretes LTDA',
                                   brand_name: 'Ache', email: 'contato@achefretes.com.br',
                                   street_name: 'Avenida Josefa Medeiros', street_number: '855',
                                   complement: 'Galpão 82', district: 'Centro', city: 'Natal', state: 'RN',
                                   postal_code: '59010000')
User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')

ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.50,
                      shipping_company: first_sc)
ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 10, end_weight: 30,
                      price_km: 1, shipping_company: second_sc)
ShippingPrice.create!(start_volume: 0.5, end_volume: 1, start_weight: 0, end_weight: 10,
                      price_km: 1, shipping_company: first_sc)
ShippingPrice.create!(start_volume: 0.5, end_volume: 1, start_weight: 10, end_weight: 30,
                      price_km: 2, shipping_company: second_sc)
ShippingPrice.create!(start_volume: 0, end_volume: 0.5, start_weight: 0, end_weight: 10, price_km: 0.45,
                      shipping_company: third_sc)

MinShippingPrice.create!(start_distance: 0, end_distance: 100, price: 100, shipping_company: first_sc)
MinShippingPrice.create!(start_distance: 100, end_distance: 200, price: 150, shipping_company: second_sc)

ShippingDeadline.create!(start_distance: 0, end_distance: 100, deadline: 2, shipping_company: first_sc)
ShippingDeadline.create!(start_distance: 100, end_distance: 300, deadline: 5, shipping_company: second_sc)
ShippingDeadline.create!(start_distance: 0, end_distance: 500, deadline: 4, shipping_company: third_sc)
ShippingDeadline.create!(start_distance: 0, end_distance: 500, deadline: 5, shipping_company: third_sc)
