class CreateVehicles < ActiveRecord::Migration[7.0]
  def change
    create_table :vehicles do |t|
      t.string :license_plate
      t.string :make
      t.string :model
      t.integer :year
      t.integer :max_load
      t.references :shipping_company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
