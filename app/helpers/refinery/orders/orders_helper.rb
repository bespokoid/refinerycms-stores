module Refinery
  module Orders
     module OrdersHelper

       def pretty_total_price( li )
         number_to_currency( ( li.quantity.to_f * li.unit_price ) )
       end

     end # module OrdersHelper
  end # module Orders
end # module Refinery
