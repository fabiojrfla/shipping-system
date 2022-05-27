class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :sku
      t.integer :height
      t.integer :width
      t.integer :length
      t.integer :weight

      t.timestamps
    end
  end
end
