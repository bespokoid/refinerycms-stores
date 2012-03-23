module Refinery
  module AuthenticatedSystem
   
    def after_sign_in_path_for(resource_or_scope)
      store_root
    end

    def after_sign_out_path_for(resource_or_scope)
      store_root
    end

    def after_update_path_for(resource)
      store_root
    end

    def after_sign_up_path_for(resource)
      store_root
    end

private
    def store_root
      refinery.stores_root_url
    end
  end
end 
