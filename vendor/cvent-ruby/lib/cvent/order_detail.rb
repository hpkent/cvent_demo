module Cvent
  class OrderDetail
    OBJECT_TYPE = "OrderDetail"

    attr_accessor :order_detail_id, :first_name, :last_name, :product_id, :product_name, :product_code, :quantity, :product_type, :product_description, :start_time, :end_time, :action, :action_date, :amount, :amount_paid, :amount_due, :order_number, :participant

    def self.create_from_hash(hash={})
      field = Cvent::OrderDetail.new

#       field.order_detail_id = hash[:@order_detail_id]
#       field.order_detail_id = hash[:@order_detail_item_id]
#       field.first_name = hash[:@first_name]
#       field.last_name = hash[:@last_name]





      ## Sometimes we recieve an array instead of a hash,
      ## and that array has no useful information, so skip it.
      if hash.is_a? Array
        field.product_type = false
        return field
      end


      field.product_name = hash[:@product_name]
#       field.product_code = hash[:@product_code]
#       field.quantity = hash[:@quantity]
      field.product_type = hash[:@product_type]
#       field.product_description = hash[:@product_description]
#       field.start_time = hash[:@start_time]
#       field.end_time = hash[:@end_time]
#       field.action = hash[:@action]
#       field.action_date = hash[:@action_date]
#       field.amount = hash[:@amount]
#       field.amount_paid = hash[:@amount_paid]
#       field.amount_due = hash[:@amount_due]
#       field.order_number = hash[:@order_number]
#       field.participant = hash[:@participant]

      return field
    end
  end
end
