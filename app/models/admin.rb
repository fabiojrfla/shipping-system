class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, :surname, presence: true
  validates :email, format: { with: %r{[a-zA-Z0-9.!\#$%&'*+/=?^_`{|}~-]+@sistemadefrete.com.br\z},
                              message: 'deve ter domínio @sistemadefrete.com.br' }
end
