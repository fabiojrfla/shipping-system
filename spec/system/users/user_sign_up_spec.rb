require 'rails_helper'

describe 'Usuário se cadastra' do
  it 'a partir da tela inicial' do
    visit root_path
    within('nav') do
      click_on 'Sou Transportadora'
    end
    click_on 'Criar conta'

    expect(current_path).to eq new_user_registration_path
    expect(page).to have_content 'Criar conta'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Sobrenome'
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Senha'
  end

  it 'com sucesso' do
    ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                            brand_name: 'TransLight', email: 'contato@translight.com.br',
                            street_name: 'Avenida Alberto Maranhão', street_number: '100', complement: 'Galpão 10',
                            district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000000')

    visit root_path
    within('nav') do
      click_on 'Sou Transportadora'
    end
    click_on 'Criar conta'
    fill_in 'Nome', with: 'Walter'
    fill_in 'Sobrenome', with: 'White'
    fill_in 'E-mail', with: 'walter@translight.com.br'
    fill_in 'Senha', with: 'saymyname'
    fill_in 'Confirme sua senha', with: 'saymyname'
    click_on 'Criar conta'

    expect(page).to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
    within('nav') do
      expect(page).to have_content 'Walter White'
      expect(page).to have_content 'walter@translight.com.br'
      expect(page).not_to have_content 'Sou Transportadora'
      expect(page).not_to have_content 'Sou Administrador'
    end
    expect(User.last.shipping_company).to eq ShippingCompany.last
  end

  it 'com dados inválidos' do
    visit root_path
    within('nav') do
      click_on 'Sou Transportadora'
    end
    click_on 'Criar conta'
    fill_in 'Nome', with: 'Walter'
    fill_in 'Sobrenome', with: ''
    fill_in 'E-mail', with: 'walter@translight.com.br'
    fill_in 'Senha', with: 'saymyname'
    fill_in 'Confirme sua senha', with: 'saymyname'
    click_on 'Criar conta'

    expect(page).to have_content 'Não foi possível salvar usuário'
    expect(page).to have_content 'Sobrenome não pode ficar em branco'
    expect(page).not_to have_content 'Nome não pode ficar em branco'
    expect(page).not_to have_content 'Shipping company é obrigatório'
  end

  it 'com e-mail que não corresponde a nenhuma empresa cadastrada' do
    ShippingCompany.create!(registration_number: '98765432000198', corporate_name: 'Light Transportes LTDA',
                            brand_name: 'TransLight', email: 'contato@translight.com.br',
                            street_name: 'Avenida Alberto Maranhão', street_number: '100', complement: 'Galpão 10',
                            district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000000')

    visit root_path
    within('nav') do
      click_on 'Sou Transportadora'
    end
    click_on 'Criar conta'
    fill_in 'Nome', with: 'Walter'
    fill_in 'Sobrenome', with: 'White'
    fill_in 'E-mail', with: 'walter@texpress.com.br'
    fill_in 'Senha', with: 'saymyname'
    fill_in 'Confirme sua senha', with: 'saymyname'
    click_on 'Criar conta'

    expect(page).to have_content 'Não foi possível salvar usuário'
    expect(page).to have_content 'E-mail não corresponde a nenhuma empresa cadastrada'
    expect(page).not_to have_content 'Nome não pode ficar em branco'
    expect(page).not_to have_content 'Sobrenome não pode ficar em branco'
  end
end
