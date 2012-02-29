module Refinery
  module Orders
    class Engine < Rails::Engine
      include Refinery::Engine
      isolate_namespace Refinery::Orders

      engine_name :refinery_stores

      initializer "register refinerycms_orders plugin" do |app|
#         Refinery::Plugin.register do |plugin|
#           plugin.name = "orders"
#           plugin.url = {
#             :controller => 'refinery/orders/admin/orders',
#             :action => 'index'
#           }
#           plugin.pathname = root

#           plugin.activity = {
#             :class_name => :'refinery/orders/order',
#             :title => 'order_status'
#           }
#           
#         end
      end

      config.after_initialize do
        Refinery.register_engine(Refinery::Orders)
      end
    end
  end
end
