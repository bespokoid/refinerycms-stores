module Refinery
  module Customers
    class Engine < Rails::Engine
      include Refinery::Engine
      isolate_namespace Refinery::Customers

      engine_name :refinery_stores

      initializer "register refinerycms_customers plugin" do |app|
        Refinery::Plugin.register do |plugin|
          plugin.name = "customers"
          plugin.url = {
            :controller => 'refinery/customers/admin/customers',
            :action => 'index'
          }
          plugin.pathname = root

          plugin.activity = {
            :class_name => :'refinery/customers/customer',
            :title => 'name'
          }
          
        end
      end

      config.after_initialize do
        Refinery.register_engine(Refinery::Customers)
      end
    end
  end
end
