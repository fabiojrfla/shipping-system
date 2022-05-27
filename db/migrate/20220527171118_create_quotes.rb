class CreateQuotes < ActiveRecord::Migration[7.0]
  def change
    create_table :quotes do |t|
      t.string :code
      t.decimal :price
      t.integer :deadline
      t.references :item, null: false, foreign_key: true
      t.references :shipping_company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
