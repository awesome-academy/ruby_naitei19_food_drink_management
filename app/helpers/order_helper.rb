module OrderHelper
  def calculate_total_price order
    order.sum do |order_item|
      quantity = order_item["quantity"].to_i
      cuisine_price = order_item["cuisine"]["price"] * quantity
      option_id = order_item["selected_option_id"]
      option = Option.find_by(id: option_id)
      cuisine_price + option&.price.to_i
    end
  end

  def calculate_price order_item
    quantity = order_item["quantity"].to_i
    price = order_item["cuisine"]["price"]
    price * quantity
  end
end
