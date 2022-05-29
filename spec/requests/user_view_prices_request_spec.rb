require 'rails_helper'

describe 'Usuário vê preços' do
  it 'se estiver autenticado' do
    get(shipping_prices_path)

    expect(response).to redirect_to new_user_session_path
  end
end
