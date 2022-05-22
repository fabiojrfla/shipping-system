class AddShippingCompanyToUser < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :shipping_company, null: false, foreign_key: true
  end
end
