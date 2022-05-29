require 'rails_helper'

RSpec.describe Item, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'SKU deve ser obrigatório' do
        item = Item.new(sku: '')
        item.valid?
        expect(item.errors.include?(:sku)).to eq true
      end

      it 'Altura deve ser obrigatório' do
        item = Item.new(height: '')
        item.valid?
        expect(item.errors.include?(:height)).to eq true
      end

      it 'Largura deve ser obrigatório' do
        item = Item.new(width: '')
        item.valid?
        expect(item.errors.include?(:width)).to eq true
      end

      it 'Comprimento deve ser obrigatório' do
        item = Item.new(length: '')
        item.valid?
        expect(item.errors.include?(:length)).to eq true
      end

      it 'Peso deve ser obrigatório' do
        item = Item.new(weight: '')
        item.valid?
        expect(item.errors.include?(:weight)).to eq true
      end
    end

    context 'uniqueness' do
      it 'SKU deve ser único' do
        Item.create!(sku: 'UGGBBPUR06', height: 70, width: 50, length: 90, weight: 5)
        item = Item.new(sku: 'UGGBBPUR06')
        item.valid?
        expect(item.errors.include?(:sku)).to eq true
      end
    end

    context 'numericality' do
      it 'Altura deve ser um número inteiro' do
        item = Item.new(height: 50.5)
        item.valid?
        expect(item.errors.include?(:height)).to eq true
      end

      it 'Largura deve ser um número inteiro' do
        item = Item.new(width: 50.5)
        item.valid?
        expect(item.errors.include?(:width)).to eq true
      end

      it 'Comprimento deve ser um número inteiro' do
        item = Item.new(length: 50.5)
        item.valid?
        expect(item.errors.include?(:length)).to eq true
      end
    end
  end

  describe '#calc_volume' do
    it 'calcula o volume em m³ a partir das dimensões em cm' do
      item = Item.new(height: 70, width: 50, length: 90)
      expect(item.calc_volume).to eq 0.315
    end
  end

  describe '#convert_g_to_kg' do
    it 'converte o Peso de gramas para kilogramas' do
      item = Item.new(weight: 5)
      item.valid?
      expect { item.convert_g_to_kg }.to change(item, :weight).from(5_000).to(5)
    end
  end

  describe 'converte o Peso de kilogramas para gramas' do
    it 'antes da validação' do
      item = Item.new(weight: 5)
      item.valid?
      expect(item.weight).to eq 5_000
    end
  end
end
