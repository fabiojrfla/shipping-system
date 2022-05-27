class ChangeStartVolumeFromIntegerToDecimal < ActiveRecord::Migration[7.0]
  def change
    change_column :shipping_prices, :start_volume, :decimal
  end
end
