require 'refinerycms-core'

module Refinery

  class Cart

    attr_reader  :items, :store_name

    def initialize( store="Your" )
      @items = []
      @store_name = store
    end

  def add_product(product)
    current_item = @items.find {|item| item.product == product}
    if current_item
      current_item.increment_quantity
    else
      current_item = ::Refinery::CartItem.new(product)
      @items << current_item
    end
    current_item
  end

  
  def total_items
    @items.sum { |item| item.quantity }
  end
  
  
  def total_price
    @items.sum { |item| item.price }
  end

  end  # class Cart

end  # module Refinery
