class ServiceOrder < ApplicationRecord
  belongs_to :quote
  belongs_to :shipping_company
  has_one :address, as: :addressable
  has_one :remittee
  accepts_nested_attributes_for :address, :remittee

  enum status: { pending: 5, accepted: 10 }

  validates :quote_id, uniqueness: true

  before_create :generate_code

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(15).upcase
  end
end
