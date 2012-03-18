module Refinery
    class StoresApplicationController < ::ApplicationController
    

private
  
  def find_cart
    find_first_store if @store.nil?
    @cart = (session[:cart] ||= Cart.new( @store.nil? ? "Your" : @store.name) )
  end
 
  def find_first_store
    @store = ::Refinery::Stores::Store.where(:is_active => true).order('position ASC').first
  end


    end  # class
end  # mod
