require 'rails_helper'

describe 'Usuário se cadastra como Admin' do
  it 'a partir da tela inicial' do
    visit root_path
    within('nav') do
      click_on 'Sou Administrador'
    end
    click_on 'Criar conta'

    expect(page).to have_content 'Criar conta'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Sobrenome'
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Senha'
  end

  it 'com sucesso' do
    visit root_path
    within('nav') do
      click_on 'Sou Administrador'
    end
    click_on 'Criar conta'

    fill_in 'Nome', with: 'Vito'
    fill_in 'Sobrenome', with: 'Corleone'
    fill_in 'E-mail', with: 'vito@sistemadefrete.com.br'
    fill_in 'Senha', with: 'whatshisname'
    fill_in 'Confirme sua senha', with: 'whatshisname'
    click_on 'Criar conta'

    expect(page).to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
    within('nav') do
      expect(page).not_to have_content 'Sou Transportadora'
      expect(page).not_to have_content 'Sou Administrador'
      expect(page).to have_content 'Vito Corleone'
      expect(page).to have_content 'vito@sistemadefrete.com.br'
    end
  end
end
