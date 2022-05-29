class MinShippingPrice < ApplicationRecord
  belongs_to :shipping_company

  validates :start_distance, :end_distance, :price, presence: true
  validates :start_distance, :end_distance, numericality: { only_integer: true }
  validates :end_distance, comparison: { greater_than: :start_distance }, allow_blank: true, if: :start_distance
  validate :not_registered

  private

  def not_registered
    return unless shipping_company

    ranges = shipping_company.min_shipping_prices.pluck(:start_distance, :end_distance)
    message = 'já inclusa em intervalo cadastrado'
    errors.add(:start_distance, message) if ranges.detect { |s, e| (s...e).include?(start_distance) }
    return unless ranges.detect { |s, e| (s...e).include?(end_distance) }

    errors.add(:end_distance, message)
  end
end
