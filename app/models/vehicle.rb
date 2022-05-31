class Vehicle < ApplicationRecord
  belongs_to :shipping_company

  validates :license_plate, :make, :model, :year, :max_load, presence: true
end
