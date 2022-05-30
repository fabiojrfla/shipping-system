require 'rails_helper'

RSpec.describe Remittee, type: :model do
  describe '#valid?' do
    it 'Nome deve ser obrigatório' do
      remittee = Remittee.new(name: '')
      remittee.valid?
      expect(remittee.errors.include?(:name)).to eq true
    end

    it 'Sobrenome deve ser obrigatório' do
      remittee = Remittee.new(surname: '')
      remittee.valid?
      expect(remittee.errors.include?(:surname)).to eq true
    end
  end

  describe '#full_name' do
    it 'retorna nome completo em uma única string' do
      remittee = Remittee.new(id_number: '341327200', name: 'Charlie', surname: 'Chaplin')
      full_name = remittee.full_name
      expect(full_name).to eq 'Charlie Chaplin'
    end
  end
end
