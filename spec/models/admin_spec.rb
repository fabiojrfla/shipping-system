require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe '#valid?' do
    it 'Nome deve ser obrigatório' do
      admin = Admin.new(name: '')
      admin.valid?
      expect(admin.errors.include?(:name)).to eq true
    end

    it 'Sobrenome deve ser obrigatório' do
      admin = Admin.new(surname: '')
      admin.valid?
      expect(admin.errors.include?(:surname)).to eq true
    end

    it 'se domínio de e-mail for @sistemadefrete.com.br' do
      admin = Admin.new(email: 'vito@sistemadefrete.com.br')
      admin.valid?
      expect(admin.errors.include?(:email)).to eq false
    end

    it 'domínio de e-mail deve ser @sistemadefrete.com.br' do
      admin = Admin.new(email: 'vito@thegodfather.com')
      admin.valid?
      expect(admin.errors.include?(:email)).to eq true
    end
  end
end
