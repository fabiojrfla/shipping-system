class CreateShippingPrices < ActiveRecord::Migration[7.0]
  def change
    create_table :shipping_prices do |t|
      t.integer :start_volume
      t.integer :end_volume
      t.integer :start_weight
      t.integer :end_weight
      t.decimal :price_km
      t.references :shipping_company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
