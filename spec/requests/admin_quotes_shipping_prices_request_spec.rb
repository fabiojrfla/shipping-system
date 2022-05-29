require 'rails_helper'

describe 'Administrador faz cotação de preços' do
  it 'se estiver autenticado' do
    get(new_item_path)

    expect(response).to redirect_to new_admin_session_path
  end
end
