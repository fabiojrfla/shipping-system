require 'rails_helper'

describe 'Administrador cadastra uma transportadora' do
  it 'com sucesso' do
    admin = Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br',
                          password: 'whatshisname')

    login_as(admin, :scope => :admin)
    visit admin_root_path
    click_on 'Transportadoras'
    click_on 'Nova Transportadora'
    fill_in 'CNPJ', with: '12345678000102'
    fill_in 'Razão Social', with: 'Transporte Expresso LTDA'
    fill_in 'Nome Fantasia', with: 'TExpress'
    fill_in 'Email', with: 'contato@texpress.com.br'
    fill_in 'Logradouro', with: 'Avenida Felipe Camarão'
    fill_in 'Número', with: '100'
    fill_in 'Complemento', with: 'Galpão 10'
    fill_in 'Bairro', with: 'Industrial'
    fill_in 'Cidade', with: 'Mossoró'
    fill_in 'Estado', with: 'RN'
    fill_in 'CEP', with: '59000000'
    click_on 'Criar Transportadora'

    expect(current_path).to eq shipping_companies_path
    expect(page).to have_content 'Transportadora cadastrada com sucesso!'
    within('table') do
      expect(page).to have_content '12345678000102'
      expect(page).to have_content 'TExpress'
      expect(page).to have_content 'Mossoró/RN'
    end
  end
end
