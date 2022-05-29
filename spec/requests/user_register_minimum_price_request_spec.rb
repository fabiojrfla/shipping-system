require 'rails_helper'

describe 'Usuário cadastra preços mínimos' do
  it 'se estiver autenticado' do
    get(new_min_shipping_price_path)

    expect(response).to redirect_to new_user_session_path
  end
end
