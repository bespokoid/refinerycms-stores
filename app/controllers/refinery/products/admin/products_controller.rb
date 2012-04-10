module Refinery
  module Products
    module Admin
      class ProductsController < ::Refinery::AdminController

        crudify :'refinery/products/product',
                :title_attribute => 'name', :xhr_paging => true


      # ----------------------------------------------------------------------
        # override crudify create
      # ----------------------------------------------------------------------
        def create
            # set this object as last object, given the conditions of this class.
          params[:product].merge!({
            :position => ((::Refinery::Products::Product.maximum(:position, :conditions => "")||-1) + 1)
          })

          @product = ::Refinery::Products::Product.new(params[:product])

          if @product.valid? && @product.save
              flash.notice = t( 'refinery.crudify.created', :what => "#{@product.name}")

              # successful creation 
            if params[:digi_download] == '1'  #   .. is digi_download needed too?
              redirect_to refinery.new_products_admin_digidownload_path( :product_id => @product.id )
            else   #..straightforward create;
              redirect_to :back
            end

          else  # unsuccesful create
            render :action => :new
          end

        end


      # ----------------------------------------------------------------------
        # override crudify update
      # ----------------------------------------------------------------------
        def update
          if @product.update_attributes(params[:product])
              # successful update
            flash.notice = t( 'refinery.crudify.updated', :what => "#{@product.name}")

            if params[:digi_download] == '1'  #   .. is digi_download needed too?
              redirect_to refinery.new_products_admin_digidownload_path( :product_id => @product.id )
            else   #..straightforward update
              redirect_to :back
            end

          else  # ... failed update
            render :action => :edit
          end
        end

      # ----------------------------------------------------------------------
      # ----------------------------------------------------------------------
      end  #  class  
    end  #  mod  
  end  #  mod  
end  #  mod  
