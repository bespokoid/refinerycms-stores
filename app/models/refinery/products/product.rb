module Refinery
  module Products
    class Product < Refinery::Core::BaseModel
      self.table_name = :refinery_products    
      acts_as_indexed :fields => [:name, :code, :description]

      validates :name, :presence => true, :uniqueness => true

      belongs_to :main_pic, :class_name => '::Refinery::Image'
      belongs_to :store, :class_name => '::Refinery::Stores::Store'
      has_many   :line_items, :class_name => '::Refinery::Orders::LineItem'
      has_one    :digidownload, :class_name => '::Refinery::Products::Digidownload'
 
      scope :active, lambda { |i| where(["date_available <= ? ", Time.now ]) }
              
# -----------------------------------------------------------------------
# select_list -- returns an html select list suitable for selecting a product
# -----------------------------------------------------------------------
   def self.select_list()
      all.map{ |x| [x.name, x.id] }
   end

              
# -----------------------------------------------------------------------
# digi_select_list -- returns an html select list of prods w/o downloads
# -----------------------------------------------------------------------
   def self.digi_select_list()
     [ ["none selected yet", nil] ] + 
     includes(:digidownload).where( :refinery_digidownloads => { :product_id => nil } ).all.map{ |x| [x.name, x.id] }
   end


# #########################################################################
   
    end
  end
end
