require 'rails_helper'

describe 'Administrador cadastra uma transportadora' do
  it 'com sucesso' do
    admin = Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br',
                          password: 'whatshisname')

    login_as(admin, scope: :admin)
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

  it 'com dados incompletos' do
    admin = Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br',
                          password: 'whatshisname')

    login_as(admin, scope: :admin)
    visit admin_root_path
    click_on 'Transportadoras'
    click_on 'Nova Transportadora'
    fill_in 'CNPJ', with: ''
    fill_in 'Razão Social', with: 'Transporte Expresso LTDA'
    fill_in 'Nome Fantasia', with: ''
    fill_in 'Email', with: 'contato@texpress.com.br'
    fill_in 'Logradouro', with: ''
    fill_in 'Número', with: '100'
    fill_in 'Complemento', with: ''
    fill_in 'Bairro', with: 'Industrial'
    fill_in 'Cidade', with: ''
    fill_in 'Estado', with: 'RN'
    fill_in 'CEP', with: ''
    click_on 'Criar Transportadora'

    expect(page).to have_content 'Dados incompletos...'
    expect(page).to have_content 'CNPJ não pode ficar em branco'
    expect(page).to have_content 'CNPJ não é válido'
    expect(page).to have_content 'Nome Fantasia não pode ficar em branco'
    expect(page).to have_content 'Logradouro não pode ficar em branco'
    expect(page).to have_content 'Cidade não pode ficar em branco'
    expect(page).to have_content 'CEP não pode ficar em branco'
    expect(page).to have_content 'CEP não é válido'

    expect(page).not_to have_content 'Razão Social não pode ficar em branco'
    expect(page).not_to have_content 'Email não pode ficar em branco'
    expect(page).not_to have_content 'Número não pode ficar em branco'
    expect(page).not_to have_content 'Bairro não pode ficar em branco'
    expect(page).not_to have_content 'Estado não pode ficar em branco'

    expect(page).to have_field 'Razão Social', with: 'Transporte Expresso LTDA'
    expect(page).to have_field 'Email', with: 'contato@texpress.com.br'
    expect(page).to have_field 'Número', with: '100'
    expect(page).to have_field 'Bairro', with: 'Industrial'
    expect(page).to have_field 'Estado', with: 'RN'
  end
end
