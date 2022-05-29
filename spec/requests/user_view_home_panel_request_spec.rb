require 'rails_helper'

describe 'Usuário vê painel inicial' do
  it 'se estiver autenticado' do
    get(user_root_path)

    expect(response).to redirect_to new_user_session_path
  end
end
