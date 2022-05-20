require 'rails_helper'

describe 'Usuário se cadastra como Admin' do
  it 'a partir da tela inicial' do
    visit root_path
    within('nav') do
      click_on 'Sou Administrador'
    end
    click_on 'Criar uma conta'

    expect(page).to have_content 'Crie sua conta'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Sobrenome'
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Senha'
  end
end
