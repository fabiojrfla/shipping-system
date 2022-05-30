class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true

  def full_address
    "#{street_name}, #{street_number}, #{complement}, #{district}, #{city}/#{state} - CEP #{postal_code}"
  end
end
