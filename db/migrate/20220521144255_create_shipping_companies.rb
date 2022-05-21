class CreateShippingCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :shipping_companies do |t|
      t.string :registration_number
      t.string :corporate_name
      t.string :brand_name
      t.string :email
      t.string :street_name
      t.string :street_number
      t.string :complement
      t.string :district
      t.string :city
      t.string :state
      t.string :postal_code
      t.integer :status, default: 5

      t.timestamps
    end
  end
end
