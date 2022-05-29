require 'rails_helper'

describe 'Administrador vê painel administrativo' do
  it 'com menu de opções' do
    admin = Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br',
                          password: 'whatshisname')

    login_as(admin, scope: :admin)
    visit admin_root_path

    expect(page).to have_content 'Painel Administrativo'
    expect(page).to have_link 'Nova Cotação'
    expect(page).to have_link 'Transportadoras'
  end
end
