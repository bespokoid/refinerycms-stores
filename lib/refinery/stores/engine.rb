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
    end
  end
end
