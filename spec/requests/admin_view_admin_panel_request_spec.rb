require 'rails_helper'

describe 'Administrador vê painel administrativo' do
  it 'se estiver autenticado' do
    get(admin_root_path)

    expect(response).to redirect_to new_admin_session_path
  end
end
