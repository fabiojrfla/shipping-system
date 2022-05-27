class ChangeEndVolumeFromIntegerToDecimal < ActiveRecord::Migration[7.0]
  def change
    change_column :shipping_prices, :end_volume, :decimal
  end
end
