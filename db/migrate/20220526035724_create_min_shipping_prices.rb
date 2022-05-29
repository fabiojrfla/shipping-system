class CreateMinShippingPrices < ActiveRecord::Migration[7.0]
  def change
    create_table :min_shipping_prices do |t|
      t.integer :start_distance
      t.integer :end_distance
      t.decimal :price
      t.references :shipping_company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
