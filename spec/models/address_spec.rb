require 'rails_helper'

RSpec.describe Address, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'Logradouro deve ser obrigatório' do
        address = Address.new(street_name: '')
        address.valid?
        expect(address.errors.include?(:street_name)).to eq true
      end

      it 'Número do endereço deve ser obrigatório' do
        address = Address.new(street_number: '')
        address.valid?
        expect(address.errors.include?(:street_number)).to eq true
      end

      it 'Bairro deve ser obrigatório' do
        address = Address.new(district: '')
        address.valid?
        expect(address.errors.include?(:district)).to eq true
      end

      it 'Cidade deve ser obrigatório' do
        address = Address.new(city: '')
        address.valid?
        expect(address.errors.include?(:city)).to eq true
      end

      it 'Estado deve ser obrigatório' do
        address = Address.new(state: '')
        address.valid?
        expect(address.errors.include?(:state)).to eq true
      end

      it 'CEP deve ser obrigatório' do
        address = Address.new(postal_code: '')
        address.valid?
        expect(address.errors.include?(:postal_code)).to eq true
      end
    end

    context 'format' do
      it 'Estado deve ter formato válido' do
        address = Address.new(state: 'RN')
        address.valid?
        expect(address.errors.include?(:state)).to eq false
      end

      it 'Estado deve ter formato válido' do
        address = Address.new(state: '84')
        address.valid?
        expect(address.errors.include?(:state)).to eq true
      end

      it 'CEP deve ter formato válido' do
        address = Address.new(postal_code: '59000000')
        address.valid?
        expect(address.errors.include?(:postal_code)).to eq false
      end

      it 'CEP deve ter formato válido' do
        first_address = Address.new(postal_code: '59000-000')
        second_address = Address.new(postal_code: '590a00z0')

        first_address.valid?
        second_address.valid?

        expect(first_address.errors.include?(:postal_code)).to eq true
        expect(second_address.errors.include?(:postal_code)).to eq true
      end
    end

    context 'lenght' do
      it 'Estado deve ter tamanho válido' do
        address = Address.new(state: 'RN')
        address.valid?
        expect(address.errors.include?(:state)).to eq false
      end

      it 'Estado deve ter tamanho válido' do
        first_address = Address.new(state: 'Rio Grande do Norte')
        second_address = Address.new(state: 'N')

        first_address.valid?
        second_address.valid?

        expect(first_address.errors.include?(:state)).to eq true
        expect(second_address.errors.include?(:state)).to eq true
      end

      it 'CEP deve ter tamanho válido' do
        address = Address.new(postal_code: '59000000')
        address.valid?
        expect(address.errors.include?(:postal_code)).to eq false
      end

      it 'CEP deve ter tamanho válido' do
        first_address = Address.new(postal_code: '590000001')
        second_address = Address.new(postal_code: '5900000')

        first_address.valid?
        second_address.valid?

        expect(first_address.errors.include?(:postal_code)).to eq true
        expect(second_address.errors.include?(:postal_code)).to eq true
      end
    end
  end

  describe '#full_address' do
    it 'retorna o endereço completo em uma única string' do
      address = Address.new(street_name: 'Avenida Rio Branco', street_number: '100', complement: 'Galpão 30',
                            district: 'Centro', city: 'Mossoró', state: 'RN', postal_code: '59000010')
      full_address = address.full_address
      expect(full_address).to eq 'Avenida Rio Branco, 100, Galpão 30, Centro, Mossoró/RN - CEP 59000010'
    end
  end
end
