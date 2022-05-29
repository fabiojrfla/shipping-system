require 'rails_helper'

describe 'Administrador vê cotações' do
  it 'se estiver autenticado' do
    get(quotes_path)

    expect(response).to redirect_to new_admin_session_path
  end
end
