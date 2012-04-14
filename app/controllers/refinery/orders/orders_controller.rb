module Refinery
  module Orders
    class OrdersController < ::ApplicationController

      # force/ensure SSL
      # ensure user registration unless anon orders okay
      # ensure state machine transitions

      before_filter :authenticate_refinery_user!

      before_filter :find_all_orders, :only => :index
      before_filter :find_order, :except => :index
      before_filter :setup_payment_gateway, :only => [:edit, :update, :purchase, :re_edit]

      helper  'refinery/stores/stores'

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @order in the line below:
        present(@order)
      end

      def show
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @order in the line below:
        present(@order)
      end

        # update must proceed within confines of order state machine
        # but must validate params as well
      def update
        @billing_address, @shipping_address = @order.handle_update( params )
        edit
      end

        # edit must present the view appropriate to order state
      def edit
        if (@action = @order.get_render_template).nil?
          flash[:notice] = "invalid order processing attempted"
          redirect_to refinery.stores_stores_path
        else
          prep_edit_view
          render :action => @action
        end  # if..then..else no action
      end

        # displays the successful purchase page
      def purchase

        @order.confirm_purchase!
        @order.process_purchase( @payment_gateway )
        
        if @order.errors.empty?
          @action = :purchase_complete
          @purchase_status = "thank you for your purchase"
        else
          @action = :purchase_pending
          @purchase_status = "Purchase unsuccessful; please correct errors and try again."
        end
      end

      def cancel_order
        @order.cancel_process!
        flash[:notice] = "you may continue your order any time"
        redirect_to refinery.stores_stores_path 
      end

      def re_edit
        @order.restart_checkout!
        edit
      end

    protected

      def find_all_orders
        @orders = current_refinery_user.orders
      end

      def find_order
        @order = Order.find(params[:id]) 
        return false unless refinery_user_signed_in? && current_refinery_user == @order.user
       end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/orders").first
      end

      def setup_payment_gateway
        @payment_gateway = ::Refinery::StoreGateway.new( @order.line_items.first.product.store )
      end

      def prep_edit_view
        @billing_address, @shipping_address = @order.get_billship_addresses( current_refinery_user )
      end

    end   #  class OrdersController
  end   #  module Orders
end   #  module Refinery

