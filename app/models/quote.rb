class Quote < ApplicationRecord
  belongs_to :item
  belongs_to :shipping_company

  validates :price, :deadline, presence: true
  validates :deadline, numericality: { only_integer: true }

  before_create :generate_code

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(12).upcase
  end
end
