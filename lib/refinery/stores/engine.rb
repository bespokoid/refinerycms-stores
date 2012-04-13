module Refinery
  module Stores
    class Engine < Rails::Engine
      include Refinery::Engine
      isolate_namespace Refinery::Stores

      engine_name :refinery_stores

      initializer "register refinerycms_stores plugin" do |app|
        Refinery::Plugin.register do |plugin|
          plugin.name = "stores"
          plugin.url = {
            :controller => 'refinery/stores/admin/stores',
            :action => 'index'
          }
          plugin.pathname = root

          plugin.activity = {
            :class_name => :'refinery/stores/store',
            :title => 'name'
          }
          
        end
      end

      config.after_initialize do
        Refinery.register_engine(Refinery::Stores)
      end

      config.to_prepare do
        ::Refinery::User.class_eval do

          
      has_many  :addresses, :class_name => ::Refinery::Addresses::Address, :foreign_key => :customer_id 
      has_many  :orders, :class_name => ::Refinery::Orders::Order, :foreign_key => :order_customer_id 
      has_many  :digidownloads, :through => :orders, :class_name => ::Refinery::Products::Digidownload
     
      has_one   :billing_address, :class_name => ::Refinery::Addresses::Address,
         :foreign_key => :customer_id,
         :conditions => { :is_billing => true, :order_id => nil }

      has_one   :shipping_address, :class_name => ::Refinery::Addresses::Address,
         :foreign_key => :customer_id,
         :conditions => { :is_billing => false, :order_id => nil }

        end  # extend user for customers
      end  # to prepare
    end
  end
end
