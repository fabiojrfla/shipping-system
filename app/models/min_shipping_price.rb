class MinShippingPrice < ApplicationRecord
  belongs_to :shipping_company

  validates :start_distance, :end_distance, :price, presence: true
  validates :start_distance, :end_distance, numericality: { only_integer: true }
  validates :end_distance, comparison: { greater_than: :start_distance }, allow_blank: true, if: :start_distance
  validate :not_registered

  private

  def range_validator(shipping_company, start_range, end_range, attr_value)
    return unless shipping_company

    shipping_company.min_shipping_prices.pluck(start_range, end_range).detect do |s, e|
      (s...e).include?(attr_value)
    end
  end

  def set_shipping_company
    return unless shipping_company_id

    ShippingCompany.find(shipping_company_id)
  end

  def not_registered
    shipping_company = set_shipping_company
    message = 'já inclusa em intervalo cadastrado'
    if range_validator(shipping_company, :start_distance, :end_distance, start_distance)
      errors.add(:start_distance, message)
    end
    return unless range_validator(shipping_company, :start_distance, :end_distance, end_distance)

    errors.add(:end_distance, message)
  end
end
