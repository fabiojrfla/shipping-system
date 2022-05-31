require 'rails_helper'

describe 'Administrador cria uma ordem de serviço' do
  it 'a partir de uma cotação' do
    admin = Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br',
                          password: 'whatshisname')
    sc = ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                 brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                 street_name: 'Avenida Felipe Camarão', street_number: '100', complement: 'Galpão 10',
                                 district: 'Industrial', city: 'Mossoró', state: 'RN', postal_code: '59000000')
    item = Item.create!(sku: 'UGGBBPUR06', height: 70, width: 50, length: 90, weight: 5)
    Quote.create!(item:, shipping_company: sc, price: 250, deadline: 4)

    login_as(admin, scope: :admin)
    visit admin_root_path
    click_on 'Cotações'
    click_on 'Criar Ordem de Serviço'

    within('h2') do
      expect(page).to have_content 'Nova Ordem de Serviço'
    end
    expect(page).to have_select 'Cotação'
    expect(page).to have_select 'Transportadora'
    within('div#remitter') do
      expect(page).to have_content 'Endereço para retirada'
      expect(page).to have_field 'Logradouro'
      expect(page).to have_field 'Número'
      expect(page).to have_field 'Complemento'
      expect(page).to have_field 'Bairro'
      expect(page).to have_field 'Cidade'
      expect(page).to have_field 'Estado'
      expect(page).to have_field 'CEP'
    end
    within('div#remittee') do
      expect(page).to have_content 'Informações para entrega'
      expect(page).to have_content 'Destinatário'
      expect(page).to have_field 'Doc. de Identificação'
      expect(page).to have_field 'Nome'
      expect(page).to have_field 'Sobrenome'
      expect(page).to have_content 'Endereço'
      expect(page).to have_field 'Logradouro'
      expect(page).to have_field 'Número'
      expect(page).to have_field 'Complemento'
      expect(page).to have_field 'Bairro'
      expect(page).to have_field 'Cidade'
      expect(page).to have_field 'Estado'
      expect(page).to have_field 'CEP'
    end
  end

  it 'com sucesso' do
    admin = Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br',
                          password: 'whatshisname')
    sc = ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                 brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                 street_name: 'Avenida Felipe Camarão', street_number: '100', complement: 'Galpão 10',
                                 district: 'Industrial', city: 'Mossoró', state: 'RN', postal_code: '59000000')
    item = Item.create!(sku: 'UGGBBPUR06', height: 70, width: 50, length: 90, weight: 5)
    Quote.create!(item:, shipping_company: sc, price: 250, deadline: 4)
    allow(SecureRandom).to receive(:alphanumeric).with(15).and_return('AVV3YOWH08M')

    login_as(admin, scope: :admin)
    visit admin_root_path
    click_on 'Cotações'
    click_on 'Criar Ordem de Serviço'
    within('div#remitter') do
      fill_in 'Logradouro', with: 'Avenida Rio Branco'
      fill_in 'Número', with: '100'
      fill_in 'Complemento', with: 'Galpão 30'
      fill_in 'Bairro', with: 'Centro'
      fill_in 'Cidade', with: 'Mossoró'
      fill_in 'Estado', with: 'RN'
      fill_in 'CEP', with: '59000010'
    end
    within('div#remittee') do
      fill_in 'Doc. de Identificação', with: '341327200'
      fill_in 'Nome', with: 'Charlie'
      fill_in 'Sobrenome', with: 'Chaplin'
      fill_in 'Logradouro', with: 'Avenida Guararapes'
      fill_in 'Número', with: '100'
      fill_in 'Complemento', with: 'Galpão 88'
      fill_in 'Bairro', with: 'Industrial'
      fill_in 'Cidade', with: 'Recife'
      fill_in 'Estado', with: 'PE'
      fill_in 'CEP', with: '50010010'
    end
    click_on 'Criar Ordem de Serviço'

    expect(page).to have_content 'Ordem de Serviço criada com sucesso!'
    expect(page).to have_content 'Ordem de Serviço AVV3YOWH08M'
    expect(page).to have_content '[Pendente]'
    expect(page).to have_content I18n.l(Time.current.to_date)
    expect(page).to have_content '12345678000102 - Transporte Expresso LTDA'
    expect(page).to have_content 'UGGBBPUR06'
    expect(page).to have_content '70 x 50 x 90cm'
    expect(page).to have_content '5kg'
    expect(page).to have_content 'Avenida Rio Branco, 100, Galpão 30, Centro, Mossoró/RN - CEP 59000010'
    expect(page).to have_content '341327200'
    expect(page).to have_content 'Charlie Chaplin'
    expect(page).to have_content 'Avenida Guararapes, 100, Galpão 88, Industrial, Recife/PE - CEP 50010010'
    expect(page).to have_content 'R$ 250'
    expect(page).to have_content '4 dias úteis'
  end

  it 'com dados inválidos' do
    admin = Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br',
                          password: 'whatshisname')
    sc = ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                                 brand_name: 'TExpress', email: 'contato@texpress.com.br',
                                 street_name: 'Avenida Felipe Camarão', street_number: '100', complement: 'Galpão 10',
                                 district: 'Industrial', city: 'Mossoró', state: 'RN', postal_code: '59000000')
    item = Item.create!(sku: 'UGGBBPUR06', height: 70, width: 50, length: 90, weight: 5)
    Quote.create!(item:, shipping_company: sc, price: 250, deadline: 4)

    login_as(admin, scope: :admin)
    visit admin_root_path
    click_on 'Cotações'
    click_on 'Criar Ordem de Serviço'
    within('div#remitter') do
      fill_in 'Logradouro', with: 'Avenida Rio Branco'
      fill_in 'Número', with: ''
      fill_in 'Complemento', with: 'Galpão 30'
      fill_in 'Bairro', with: ''
      fill_in 'Cidade', with: 'Mossoró'
      fill_in 'Estado', with: ''
      fill_in 'CEP', with: '59000010'
    end
    within('div#remittee') do
      fill_in 'Doc. de Identificação', with: '341327200'
      fill_in 'Nome', with: ''
      fill_in 'Sobrenome', with: 'Chaplin'
      fill_in 'Logradouro', with: ''
      fill_in 'Número', with: '100'
      fill_in 'Complemento', with: ''
      fill_in 'Bairro', with: 'Industrial'
      fill_in 'Cidade', with: ''
      fill_in 'Estado', with: 'PE'
      fill_in 'CEP', with: ''
    end
    click_on 'Criar Ordem de Serviço'

    expect(page).to have_content 'Dados inválidos...'
    expect(page).to have_content 'Número não pode ficar em branco'
    expect(page).to have_content 'Bairro não pode ficar em branco'
    expect(page).to have_content 'Estado não pode ficar em branco'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Logradouro não pode ficar em branco'
    expect(page).to have_content 'Cidade não pode ficar em branco'
    expect(page).to have_content 'CEP não pode ficar em branco'

    expect(page).not_to have_content 'Doc. de Identificação não pode ficar em branco'
    expect(page).not_to have_content 'Sobrenome não pode ficar em branco'

    expect(page).to have_field 'Logradouro', with: 'Avenida Rio Branco'
    expect(page).to have_field 'Doc. de Identificação', with: '341327200'
    expect(page).to have_field 'Bairro', with: 'Industrial'
  end
end
