module Refinery
  module Orders
    class LineItem < Refinery::Core::BaseModel
      self.table_name = :refinery_line_items    

      belongs_to :order
      belongs_to :product, :class_name => ::Refinery::Products::Product

#       validates :order_status, :presence => true, :uniqueness => true
              
      def self.from_cart_item( item )
        return  self.create(
          :product    => item.product,
          :quantity   => item.quantity,
          :unit_price => item.price
        )

      end

    end  # class LineItem

  end  # module Orders

end  # module Refinery
