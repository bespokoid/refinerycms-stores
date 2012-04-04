module Refinery
  module Products
    class Product < Refinery::Core::BaseModel
      self.table_name = :refinery_products    
      acts_as_indexed :fields => [:name, :code, :description]

      validates :name, :presence => true, :uniqueness => true

      belongs_to :main_pic, :class_name => '::Refinery::Image'
      belongs_to :store, :class_name => '::Refinery::Stores::Store'
      has_many   :line_items, :class_name => '::Refinery::Orders::LineItem'
 
      scope :active, lambda { |i| where(["date_available <= ? ", Time.now ]) }
              
# -----------------------------------------------------------------------
# select_list -- returns an html select list suitable for selecting a store
# -----------------------------------------------------------------------
   def self.select_list()
      all.map{ |x| [x.name, x.id] }
   end

  
    end
  end
end
