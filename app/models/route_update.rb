class RouteUpdate < ApplicationRecord
  belongs_to :service_order

  validates :description, :place_name, :city, :state, presence: true
end
