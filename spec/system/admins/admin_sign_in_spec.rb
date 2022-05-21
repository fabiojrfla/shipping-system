require 'rails_helper'

describe 'Administrador se autentica' do
  it 'com sucesso' do
    Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br', password: 'whatshisname')

    visit root_path
    within('nav') do
      click_on 'Sou Administrador'
    end
    click_on 'Entrar'
    within('form') do
      fill_in 'E-mail', with: 'vito@sistemadefrete.com.br'
      fill_in 'Senha', with: 'whatshisname'
      click_on 'Entrar'
    end

    expect(page).to have_content 'Login efetuado com sucesso.'
    within('nav') do
      expect(page).not_to have_content 'Página inicial'
      expect(page).not_to have_content 'Rastreamento'
      expect(page).not_to have_content 'Sou Transportadora'
      expect(page).not_to have_content 'Sou Administrador'
      expect(page).to have_content 'Vito Corleone'
      expect(page).to have_content 'vito@sistemadefrete.com.br'
      expect(page).to have_button 'Sair'
    end
  end
end
