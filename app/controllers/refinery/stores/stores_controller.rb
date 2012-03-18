module Refinery
  module Stores
    class StoresController < ::Refinery::StoresApplicationController

      before_filter :find_first_store, :only => :index
      before_filter :find_page, :except => [:index, :add_to_cart, :empty_cart, :checkout]
      before_filter :find_cart, :except => :empty_cart

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @store in the line below:
        if @store.nil?  # if there is no active store
          find_all_stores   # then prob show an empty page
          present(@page)
        else  # else show the active store directly
          redirect_to refinery.stores_store_path( @store )
        end
      end

      def show
        @store = Store.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @store in the line below:
        present(@page)
      end

  def add_to_cart
    begin                     
      product = ::Refinery::Products::Product.find(params[:id])  
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid product #{params[:id]}")
      redirect_to_index("Invalid product")
    else
      @current_item = @cart.add_product(product)
      redirect_to_index unless request.xhr?
    end
  end

  def empty_cart
    session[:cart] = nil
    redirect_to_index
  end

  
  def checkout
    if @cart.items.empty?
      redirect_to_index("Your cart is empty")
    else
      @order = ::Refinery::Orders::Order.checkout!( @cart )
      session[:cart] = nil
      redirect_to   refinery.edit_orders_order_path( @order )
    end
  end
  
  private
  
  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to refinery.stores_store_path( find_first_store )
  end
    
 
    protected

      def find_first_store
        @store = Store.where(:is_active => true).order('position ASC').first
      end


      def find_all_stores
        @stores = Store.order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/stores").first
      end

    end
  end
end
