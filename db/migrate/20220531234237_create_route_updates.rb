class CreateRouteUpdates < ActiveRecord::Migration[7.0]
  def change
    create_table :route_updates do |t|
      t.string :description
      t.string :place_name
      t.string :city
      t.string :state
      t.references :service_order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
