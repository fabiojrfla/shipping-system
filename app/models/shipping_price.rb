class ShippingPrice < ApplicationRecord
  belongs_to :shipping_company

  validates :price_km, presence: true
end
