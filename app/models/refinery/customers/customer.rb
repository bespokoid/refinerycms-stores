module Refinery
  module Customers
    class Customer < ::Refinery::User

      has_many  :addresses, :class_name => ::Refinery::Addresses::Address 
      has_many  :orders, :class_name => ::Refinery::Orders::Order, :foreign_key => :order_customer_id 
    
      has_one   :billing_address, :class_name => ::Refinery::Addresses::Address,
         :conditions => { :is_billing => true, :order_id => nil }

      has_one   :shipping_address, :class_name => ::Refinery::Addresses::Address,
         :conditions => { :is_billing => false, :order_id => nil }

              
    end
  end
end
