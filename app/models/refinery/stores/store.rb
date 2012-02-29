module Refinery
  module Stores
    class Store < Refinery::Core::BaseModel
      self.table_name = :refinery_stores      
    
      acts_as_indexed :fields => [:name, :meta_keywords, :description]

      validates :name, :presence => true, :uniqueness => true
              
     has_many   :products
         # we may want to expand the concept of active in the future
      has_many   :active_products, :class_name => '::Refinery::Products::Product', :foreign_key => 'store_id'
              
# -----------------------------------------------------------------------
# select_list -- returns an html select list suitable for selecting a store
# -----------------------------------------------------------------------
   def self.select_list()
      all.map{ |x| [x.name, x.id] }
   end

# -----------------------------------------------------------------------
# -----------------------------------------------------------------------
     
# -----------------------------------------------------------------------
# -----------------------------------------------------------------------
     
# -----------------------------------------------------------------------
# -----------------------------------------------------------------------

    end  # class Store

  end  # module Stores
end  # module Refineryd
