require 'rails_helper'

describe 'Usuário se autentica' do
  it 'com sucesso' do
    ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                            brand_name: 'TransLight', email: 'contato@translight.com.br',
                            street_name: 'Avenida Alberto Maranhão', street_number: '100', complement: 'Galpão 10',
                            district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000000')
    User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')

    visit root_path
    within('nav') do
      click_on 'Sou Transportadora'
    end
    within('form') do
      fill_in 'E-mail', with: 'walter@translight.com.br'
      fill_in 'Senha', with: 'saymyname'
      click_on 'Entrar'
    end

    expect(page).to have_content 'Login efetuado com sucesso.'
    within('nav') do
      expect(page).to have_content 'Walter White'
      expect(page).to have_content 'walter@translight.com.br'
      expect(page).to have_button 'Sair'
      expect(page).not_to have_content 'Página inicial'
      expect(page).not_to have_content 'Rastreamento'
      expect(page).not_to have_content 'Sou Transportadora'
      expect(page).not_to have_content 'Sou Administrador'
    end
  end

  it 'e faz logout' do
    ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                            brand_name: 'TransLight', email: 'contato@translight.com.br',
                            street_name: 'Avenida Alberto Maranhão', street_number: '100', complement: 'Galpão 10',
                            district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000000')
    User.create!(name: 'Walter', surname: 'White', email: 'walter@translight.com.br', password: 'saymyname')

    visit root_path
    within('nav') do
      click_on 'Sou Transportadora'
    end
    within('form') do
      fill_in 'E-mail', with: 'walter@translight.com.br'
      fill_in 'Senha', with: 'saymyname'
      click_on 'Entrar'
    end
    click_on 'Sair'

    expect(page).to have_content 'Logout efetuado com sucesso.'
    within('nav') do
      expect(page).to have_content 'Página inicial'
      expect(page).to have_content 'Rastreamento'
      expect(page).to have_content 'Sou Transportadora'
      expect(page).to have_content 'Sou Administrador'
      expect(page).not_to have_content 'Walter White'
      expect(page).not_to have_content 'walter@translight.com.br'
      expect(page).not_to have_button 'Sair'
    end
  end
end
