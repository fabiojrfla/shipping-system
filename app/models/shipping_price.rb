class ShippingPrice < ApplicationRecord
  belongs_to :shipping_company

  validates :start_volume, :end_volume, :start_weight, :end_weight, :price_km, presence: true
  validates :end_volume, comparison: { greater_than: :start_volume }, allow_blank: true, if: :start_volume
  validates :end_weight, comparison: { greater_than: :start_weight }, allow_blank: true, if: :start_weight
  validate :not_registered

  before_validation :convert_kg_to_g

  def calc_price(distance)
    price_km * distance
  end

  def convert_g_to_kg
    self.start_weight /= 1_000 if start_weight
    self.end_weight /= 1_000 if end_weight
  end

  private

  def convert_kg_to_g
    self.start_weight *= 1_000 if start_weight
    self.end_weight *= 1_000 if end_weight
  end

  def range_validator(ranges, attr_value)
    ranges.detect do |s, e|
      (s...e).include?(attr_value)
    end
  end

  def not_registered
    return unless shipping_company

    volume_ranges = shipping_company.shipping_prices.pluck(:start_volume, :end_volume)
    weight_ranges = shipping_company.shipping_prices.pluck(:start_weight, :end_weight)
    volume_validator = []
    volume_validator << range_validator(volume_ranges, start_volume)
    volume_validator << range_validator(volume_ranges, end_volume)
    weight_validator = []
    weight_validator << range_validator(weight_ranges, start_weight)
    weight_validator << range_validator(weight_ranges, end_weight)

    return unless volume_validator.any? && weight_validator.any?

    message = 'Intervalos de volume e de peso já cadastrados'
    errors.add(:base, message)
  end
end
