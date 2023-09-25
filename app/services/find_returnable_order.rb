class FindReturnableOrder
  def self.return_order(employee, order_id)
    process_return(employee, Order.fulfilled.where(id: order_id).first)
  end

  def self.process_return(employee, order)
    if order
      ReturnInventory.run(employee, order.inventories, order)
    end
  end
  private_class_method :process_return
end
