require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    it 'Nome deve ser obrigatório' do
      user = User.new(name: '')
      user.valid?
      expect(user.errors.include?(:name)).to eq true
    end

    it 'Sobrenome deve ser obrigatório' do
      user = User.new(surname: '')
      user.valid?
      expect(user.errors.include?(:surname)).to eq true
    end

    it 'Domínio de e-mail deve ser o mesmo de uma transportadora cadastrada' do
      ShippingCompany.create!(registration_number: '12345678000102', corporate_name: 'Transporte Expresso LTDA',
                              brand_name: 'TExpress', email: 'contato@texpress.com.br',
                              street_name: 'Avenida Felipe Camarão', street_number: '100', complement: 'Galpão 10',
                              district: 'Industrial', city: 'Mossoró', state: 'RN', postal_code: '59000000')
      user = User.new(email: 'walter@translight.com.br')

      user.valid?

      expect(user.errors.include?(:email)).to eq true
    end
  end
end
