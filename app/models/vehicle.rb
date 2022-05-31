class Vehicle < ApplicationRecord
  belongs_to :shipping_company
  has_many :service_orders

  validates :license_plate, :make, :model, :year, :max_load, presence: true

  def full_description
    "#{license_plate} - #{make} #{model}"
  end
end
