require 'rails_helper'

describe 'Visitante acessa tela inicial' do
  it 'e vê o nome da aplicação' do
    visit root_path

    within('h1') do
      expect(page).to have_content 'Sistema de Frete'
    end
  end

  it 'e vê menu de navegação' do
    visit root_path

    within('nav') do
      expect(page).to have_content 'Página inicial'
      expect(page).to have_content 'Rastreamento'
      expect(page).to have_content 'Sou Transportadora'
      expect(page).to have_content 'Sou Administrador'
    end
  end
end
