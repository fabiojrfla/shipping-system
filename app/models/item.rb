class Item < ApplicationRecord
  validates :sku, :height, :width, :length, :weight, presence: true
  validates :sku, uniqueness: true
  validates :height, :width, :length, numericality: { only_integer: true }

  before_validation :convert_kg_to_g

  def calc_volume
    (height * width * length) / 1_000_000.to_d
  end

  def convert_g_to_kg
    self.weight /= 1_000 if weight
  end

  def full_dimensions
    "#{height} x #{width} x #{length}cm"
  end

  private

  def convert_kg_to_g
    self.weight *= 1_000 if weight
  end
end
