require 'rails_helper'

describe 'Administrador vê painel administrativo' do
  it 'se estiver autenticado' do
    visit admin_root_path

    expect(current_path).to eq new_admin_session_path
  end

  it 'com menu de opções' do
    admin = Admin.create!(name: 'Vito', surname: 'Corleone', email: 'vito@sistemadefrete.com.br',
                          password: 'whatshisname')

    login_as(admin, scope: :admin)
    visit admin_root_path

    expect(page).to have_link 'Transportadoras'
  end
end
