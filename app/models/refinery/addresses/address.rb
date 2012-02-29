module Refinery
  module Addresses
    class Address < Refinery::Core::BaseModel
      self.table_name = :refinery_addresses    
      # acts_as_indexed :fields => [:first_name, :last_name, :phone, :email, :address1, :address2, :city, :state, :zip, :country]

      validates :first_name, :presence => true
      validates :last_name,  :presence => true
              
    end
  end
end
