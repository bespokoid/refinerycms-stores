module Refinery
  module Products
    class Product < Refinery::Core::BaseModel
      self.table_name = :refinery_products    
      acts_as_indexed :fields => [:name, :code, :description]

      validates :name, :presence => true, :uniqueness => true

      belongs_to :main_pic, :class_name => '::Refinery::Image'
      belongs_to :store
      has_many   :line_items
 
      scope :active, lambda { |i| where(["date_available <= ? ", Time.now ]) }
  
    end
  end
end
