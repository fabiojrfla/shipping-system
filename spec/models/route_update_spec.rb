require 'rails_helper'

RSpec.describe RouteUpdate, type: :model do
  context 'presence' do
    it 'Descrição deve ser obrigatório' do
      route_update = RouteUpdate.new(description: '')
      route_update.valid?
      expect(route_update.errors.include?(:description)).to eq true
    end

    it 'Nome da Unidade deve ser obrigatório' do
      route_update = RouteUpdate.new(place_name: '')
      route_update.valid?
      expect(route_update.errors.include?(:place_name)).to eq true
    end

    it 'Cidade deve ser obrigatório' do
      route_update = RouteUpdate.new(city: '')
      route_update.valid?
      expect(route_update.errors.include?(:city)).to eq true
    end

    it 'Estado deve ser obrigatório' do
      route_update = RouteUpdate.new(state: '')
      route_update.valid?
      expect(route_update.errors.include?(:state)).to eq true
    end
  end
end
