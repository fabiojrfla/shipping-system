class CreateServiceOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :service_orders do |t|
      t.string :code
      t.references :quote, null: false, foreign_key: true

      t.timestamps
    end
  end
end
