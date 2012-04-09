module Refinery
  module Products
    module Admin
      class ProductsController < ::Refinery::AdminController

        crudify :'refinery/products/product',
                :title_attribute => 'name', :xhr_paging => true

        def successful_create
          if params[:digi_download] == '1'
            @redirect_to_url = 
              refinery.new_products_admin_digidownloads_path( :product_id => @product.id )
          end
          super
        end

      end
    end
  end
end
