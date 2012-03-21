module Refinery
    class StoresApplicationController < ::ApplicationController

      after_filter  :set_return_location
    
private
  
  def find_cart
    find_first_store if @store.nil?
    @cart = (session[:cart] ||= Cart.new( @store.nil? ? "Your" : @store.name) )
  end
 
  def find_first_store
    @store = ::Refinery::Stores::Store.where(:is_active => true).order('position ASC').first
  end

  def set_return_location
    session[:return_to] = refinery.stores_stores_url()
  end


    end  # class
end  # mod
