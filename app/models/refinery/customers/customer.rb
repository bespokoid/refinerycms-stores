module Refinery
  module Customers
    class Customer < ::Refinery::User

      has_many  :addresses, :class_name => ::Refinery::Addresses::Address 
      has_many  :orders, :class_name => ::Refinery::Orders::Order, :foreign_key => :order_customer_id 
    
      has_one   :billing_address, :class_name => ::Refinery::Addresses::Address,
         :conditions => { :is_billing => true, :order_id => nil }

      has_one   :shipping_address, :class_name => ::Refinery::Addresses::Address,
         :conditions => { :is_billing => false, :order_id => nil }

      Refinery::User.class_eval do
        def self.find_by_parameterized_username( p_id )
          Refinery::User.all.detect{|u| u.to_param == p_id }
        end
      end   # class_eval do 
    end
  end
end
