class Quote < ApplicationRecord
  belongs_to :item
  belongs_to :shipping_company
end
