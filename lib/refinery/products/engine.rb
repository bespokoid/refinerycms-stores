module Refinery
  module Products
    class Engine < Rails::Engine
      include Refinery::Engine
      isolate_namespace Refinery::Products

      engine_name :refinery_stores

#     initializer "register refinerycms_products plugin" do |app|
#         Refinery::Plugin.register do |plugin|
#           plugin.name = "products"
#           plugin.url = {
#             :controller => 'refinery/products/admin/products',
#             :action => 'index'
#           }
#           plugin.pathname = root

#           plugin.activity = {
#             :class_name => :'refinery/products/product',
#             :title => 'name'
#           }
#           
#         end
#     end

      config.after_initialize do
        Refinery.register_engine(Refinery::Products)
      end
    end
  end
end
