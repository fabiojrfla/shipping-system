class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :shipping_company

  before_validation :assign_shipping_company, on: :create

  validates :name, :surname, presence: true
  validate :email_eq_to_registered_shipping_company

  after_validation :delete_shipping_company_error

  private

  def email_eq_to_registered_shipping_company
    domain = "@#{email.split('@').last}"
    match = ShippingCompany.pluck(:email).detect { |email| email.end_with?(domain) }
    errors.add(:email, 'não corresponde a nenhuma empresa cadastrada') unless match
  end

  def assign_shipping_company
    domain = "@#{email.split('@').last}"
    self.shipping_company = ShippingCompany.where('email LIKE ?',
                                                  "%#{ShippingCompany.sanitize_sql_like(domain)}").first
  end

  def delete_shipping_company_error
    errors.delete(:shipping_company)
  end
end
