module Refinery
  module Customers
     module CustomersHelper

       def pretty_customer_name( user )
         name = ( user.billing_address.nil?  ?  
                 user.username  : 
                 user.billing_address.first_name )
         return "Hi #{name}!"
       end

     end # module CustomersHelper
  end # module Customers
end # module Refinery
