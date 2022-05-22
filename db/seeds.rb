Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br', password: 'whatshisname')

ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                        brand_name: 'TExpress', email: 'contato@texpress.com.br',
                        street_name: 'Avenida Felipe Camarão', street_number: '100', complement: 'Galpão 10',
                        district: 'Industrial', city: 'Mossoró', state: 'RN', postal_code: '59000000')
ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                        brand_name: 'TransLight', email: 'contato@translight.com.br',
                        street_name: 'Avenida Alberto Maranhão', street_number: '100', complement: 'Galpão 10',
                        district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000000')

User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')
