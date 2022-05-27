class Item < ApplicationRecord
  before_validation :convert_kg_to_g

  def calc_volume
    (height * width * length) / 1_000_000.to_d
  end

  private

  def convert_kg_to_g
    self.weight *= 1_000 if weight
  end
end
