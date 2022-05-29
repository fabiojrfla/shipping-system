class CreateShippingDeadlines < ActiveRecord::Migration[7.0]
  def change
    create_table :shipping_deadlines do |t|
      t.integer :start_distance
      t.integer :end_distance
      t.integer :deadline
      t.references :shipping_company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
