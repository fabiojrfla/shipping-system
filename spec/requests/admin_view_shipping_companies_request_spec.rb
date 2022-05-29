require 'rails_helper'

describe 'Administrador vê transportadoras' do
  it 'se estiver autenticado' do
    get(shipping_companies_path)

    expect(response).to redirect_to new_admin_session_path
  end
end
