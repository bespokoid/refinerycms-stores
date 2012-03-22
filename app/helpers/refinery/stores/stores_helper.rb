module Refinery
  module Stores
     module StoresHelper

       def pretty_customer_name( )
         user = current_refinery_user  # might raise exception
         return  "please&hellip;".html_safe if user.nil?

         name = ( user.billing_address.nil?  ?  
                 user.username  : 
                 user.billing_address.first_name )
         return "Hi #{name}!"

        rescue NameError
          return  "please&hellip;".html_safe
       end

       def is_user_signed_in?()

         return refinery_current_user

       rescue NameError
         return  nil
       end

     end # module StoresHelper
  end # module Stores
end # module Refinery
