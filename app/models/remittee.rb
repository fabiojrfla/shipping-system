class Remittee < ApplicationRecord
  belongs_to :service_order
  has_one :address, as: :addressable
  accepts_nested_attributes_for :address

  validates :name, :surname, presence: true

  def full_name
    "#{name} #{surname}"
  end
end
