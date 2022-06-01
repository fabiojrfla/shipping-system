class ServiceOrder < ApplicationRecord
  belongs_to :quote
  belongs_to :shipping_company
  belongs_to :vehicle, optional: true
  has_one :address, as: :addressable
  has_one :remittee
  has_many :route_updates
  accepts_nested_attributes_for :address, :remittee

  enum status: { pending: 5, accepted: 10, rejected: 15, in_transit: 20, finished: 25 }

  validates :quote_id, uniqueness: true

  before_create :generate_code

  def route_updates_attributes=(route_updates_attributes)
    route_updates_attributes.each do |i, attributes|
      route_updates.build(attributes)
    end
  end

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(15).upcase
  end
end
