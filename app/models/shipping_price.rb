class ShippingPrice < ApplicationRecord
  belongs_to :shipping_company

  validates :start_volume, :end_volume, :start_weight, :end_weight, :price_km, presence: true
  validates :start_volume, :end_volume, numericality: { only_integer: true }
  validates :end_volume, comparison: { greater_than: :start_volume }, allow_blank: true, if: :start_volume
  validates :end_weight, comparison: { greater_than: :start_weight }, allow_blank: true, if: :start_weight
  validate :not_registered

  before_validation :convert_kg_to_g

  private

  def convert_kg_to_g
    self.start_weight *= 1_000 if start_weight
    self.end_weight *= 1_000 if end_weight
  end

  def range_validator(shipping_company, start_range, end_range, attr_value)
    return unless shipping_company

    shipping_company.shipping_prices.pluck(start_range, end_range).detect do |s, e|
      (s..e).include?(attr_value)
    end
  end

  def set_shipping_company
    return unless shipping_company_id

    ShippingCompany.find(shipping_company_id)
  end

  def not_registered
    shipping_company = set_shipping_company
    volume_validator = []
    weight_validator = []
    volume_validator << range_validator(shipping_company, :start_volume, :end_volume, start_volume)
    volume_validator << range_validator(shipping_company, :start_volume, :end_volume, end_volume)
    weight_validator << range_validator(shipping_company, :start_weight, :end_weight, start_weight)
    weight_validator << range_validator(shipping_company, :start_weight, :end_weight, end_weight)

    return unless volume_validator.any? && weight_validator.any?

    message = 'Intervalos de volume e de peso já cadastrados'
    errors.add(:base, message)
  end
end
