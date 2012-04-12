module Refinery
  module Orders
    class LineItem < Refinery::Core::BaseModel
      self.table_name = :refinery_line_items    

      belongs_to :order
      belongs_to :product, :class_name => ::Refinery::Products::Product
      has_one    :digidownload, :through => :product, :class_name => ::Refinery::Products::Digidownload

#       validates :order_status, :presence => true, :uniqueness => true
              
      def self.from_cart_item( item )
        return  self.create(
          :product    => item.product,
          :quantity   => item.quantity,
          :unit_price => item.price
        )

      end

      def self.has_digidownloads?( order_id )
        self.joins( :product, :digidownload ).
             where( 
                   "\"refinery_line_items\".order_id = #{order_id}" +
                   " AND \"refinery_products\".id =  \"refinery_line_items\".product_id" + 
                     " AND \"refinery_digidownloads\".product_id = \"refinery_products\".id ").
             count > 0
      end

    end  # class LineItem

  end  # module Orders

end  # module Refinery
