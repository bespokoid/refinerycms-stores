module Refinery
  module Addresses
    class Address < Refinery::Core::BaseModel
      self.table_name = :refinery_addresses    
      # acts_as_indexed :fields => [:first_name, :last_name, :phone, :email, :address1, :address2, :city, :state, :zip, :country]

      validates :first_name, :presence => true
      validates :last_name,  :presence => true

      belongs_to  :order, :class_name => ::Refinery::Orders::Order
      belongs_to  :customer, :class_name => ::Refinery::Customers::Customer

# ---------------------------------------------------------------------------
  # update_addresses -- complex logic for dealing with 2 order addresses
  # return bill_address, ship_address objects
  # args:
  #   parent_obj is the object to which the addresses belong
  #     (either customer or order)
  #   params -- user input parameters
# ---------------------------------------------------------------------------
   def self.update_addresses(parent_obj, params )
     # if bill exists; update with parameters
     # else create bill
      if (bill_address  = parent_obj.billing_address)
         bill_address.update_attributes( params[:billing_address] )
      else
         bill_address = parent_obj.addresses.create( 
              params[:billing_address].merge( { :is_billing => true } ) 
         )
      end  # if..then..else billing address setup

         # continue if error free
      if bill_address.errors.empty?

           # does customer wants same address for both ?
         ship_params = ( params[:use_billing]  ?  
                        params[:billing_address]  :  
                        params[:shipping_address] 
         ).merge( { :is_billing => false } )

         if (ship_address  = parent_obj.shipping_address)
            ship_address.update_attributes( ship_params )
         else
            ship_address = parent_obj.addresses.create( ship_params )
         end  # if..then..else shiping address setup

      else #  need placeholder for re-editing the order
        ship_address = parent_obj.addresses.build( params[:shipping_address] )
      end  # if no bill address errors

      return bill_address, ship_address
   end

              
    end
  end
end
