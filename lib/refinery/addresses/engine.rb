module Refinery
  module Addresses
    class Engine < Rails::Engine
      include Refinery::Engine
      isolate_namespace Refinery::Addresses

      engine_name :refinery_stores

      initializer "register refinerycms_addresses plugin" do |app|
#         Refinery::Plugin.register do |plugin|
#           plugin.name = "addresses"
#           plugin.url = {
#             :controller => 'refinery/addresses/admin/addresses',
#             :action => 'index'
#           }
#           plugin.pathname = root

#           plugin.activity = {
#             :class_name => :'refinery/addresses/address',
#             :title => 'first_name'
#           }
#           
#         end
      end

      config.after_initialize do
        Refinery.register_engine(Refinery::Addresses)
      end
    end
  end
end
