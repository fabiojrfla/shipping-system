require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe '#valid?' do
    context 'present' do
      it 'Placa deve ser obrigatório' do
        vehicle = Vehicle.new(license_plate: '')
        vehicle.valid?
        expect(vehicle.errors.include?(:license_plate)).to eq true
      end

      it 'Marca deve ser obrigatório' do
        vehicle = Vehicle.new(make: '')
        vehicle.valid?
        expect(vehicle.errors.include?(:make)).to eq true
      end

      it 'Modelo deve ser obrigatório' do
        vehicle = Vehicle.new(model: '')
        vehicle.valid?
        expect(vehicle.errors.include?(:model)).to eq true
      end

      it 'Ano de Fabricação deve ser obrigatório' do
        vehicle = Vehicle.new(year: '')
        vehicle.valid?
        expect(vehicle.errors.include?(:year)).to eq true
      end

      it 'Carga Máxima (kg) deve ser obrigatório' do
        vehicle = Vehicle.new(max_load: '')
        vehicle.valid?
        expect(vehicle.errors.include?(:max_load)).to eq true
      end
    end
  end
end
