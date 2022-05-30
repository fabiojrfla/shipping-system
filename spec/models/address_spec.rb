require 'rails_helper'

RSpec.describe Address, type: :model do
  describe '#full_address' do
    it 'retorna o endereço completo em uma única string' do
      address = Address.new(street_name: 'Avenida Rio Branco', street_number: '100', complement: 'Galpão 30',
                            district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000010')
      full_address = address.full_address
      expect(full_address).to eq 'Avenida Rio Branco, 100, Galpão 30, Centro, Mossoró/RN - CEP 59000010'
    end
  end
end
