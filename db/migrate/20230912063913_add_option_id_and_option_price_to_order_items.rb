class AddOptionIdAndOptionPriceToOrderItems < ActiveRecord::Migration[7.0]
  def change
    add_column :order_items, :option_id, :integer
    add_column :order_items, :option_price, :decimal
  end
end
