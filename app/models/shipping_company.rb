class ShippingCompany < ApplicationRecord
  has_many :shipping_prices
  has_many :min_shipping_prices
  has_many :shipping_deadlines
  has_many :vehicles

  enum status: { active: 5, inactive: 10 }

  validates :registration_number, :corporate_name, :brand_name, :email, :street_name, :street_number, :district, :city,
            :state, :postal_code, presence: true
  validates :registration_number, :email, uniqueness: true
  validates :registration_number, format: { with: /\A\d{14}\z/ }
  validates :state, format: { with: /\A[A-Z]{2}\z/ }
  validates :postal_code, format: { with: /\A\d{8}\z/ }
  validates :registration_number, length: { is: 14 }
  validates :state, length: { is: 2 }
  validates :postal_code, length: { is: 8 }

  def full_description
    "#{registration_number} - #{corporate_name}"
  end
end
