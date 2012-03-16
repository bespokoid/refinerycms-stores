module Refinery
    class StoresApplicationController < ::ApplicationController
    

protected
  
  def find_cart
    @cart = (session[:cart] ||= Cart.new)
  end
 
    end  # class
end  # mod
