require 'rails_helper'

RSpec.describe Remittee, type: :model do
  describe '#full_name' do
    it 'retorna nome completo em uma única string' do
      remittee = Remittee.new(id_number: '341327200', name: 'Charlie', surname: 'Chaplin')
      full_name = remittee.full_name
      expect(full_name).to eq 'Charlie Chaplin'
    end
  end
end
