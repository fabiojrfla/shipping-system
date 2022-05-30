class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true

  validates :street_name, :street_number, :city, :district, :state, :postal_code, presence: true
  validates :state, format: { with: /\A[A-Z]{2}\z/ }
  validates :postal_code, format: { with: /\A\d{8}\z/ }
  validates :state, length: { is: 2 }
  validates :postal_code, length: { is: 8 }

  def full_address
    "#{street_name}, #{street_number}, #{complement}, #{district}, #{city}/#{state} - CEP #{postal_code}"
  end
end
