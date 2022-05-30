class CreateRemittees < ActiveRecord::Migration[7.0]
  def change
    create_table :remittees do |t|
      t.string :id_number
      t.string :name
      t.string :surname
      t.references :service_order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
