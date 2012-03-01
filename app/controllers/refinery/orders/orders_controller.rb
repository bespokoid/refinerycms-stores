module Refinery
  module Orders
    class OrdersController < ::ApplicationController

      # force/ensure SSL
      # ensure user registration unless anon orders okay
      # ensure state machine transitions

      before_filter :find_all_orders, :only => :index
      before_filter :find_order, :except => :index

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
        Stripe.api_key = secret_key
        @order.confirm_purchase!
        if @order.errors.empty?

          # TODO: remove the following; this is for test only
          @order.payment_verified!  unless Rails.env.production?

          flash[:notice] = "thank you for your purchase"
        else
          flash[:notice] = "we could not complete your purchase"
          edit
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
        @orders = Order.order('position ASC')
      end

      def find_order
        @order = Order.find(params[:id]) 
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/orders").first
      end

      def prep_edit_view
        if @billing_address.nil?
          @billing_address, @shipping_address = @order.get_billship_addresses
        end
        # setup the keys for the payment gateway
        # TODO: make this variable by gateway type
        payment_gateway = "stripe"
        payment_mode = ( Rails.env.production?  ?  'live'  :  'test' )
        payment_settings = "#{payment_gateway}_#{payment_mode}"
        @payment_access_url = ::Refinery::Setting.find_or_set( "#{payment_settings}_access_url".to_sym, "access URL missing" )
        @payment_secret_key = ::Refinery::Setting.find_or_set( "#{payment_settings}_secret_key".to_sym, "secret key missing" )
        @payment_api_key    = ::Refinery::Setting.find_or_set( "#{payment_settings}_api_key".to_sym,    "API key missing" )
      end

    end   #  class OrdersController
  end   #  module Orders
end   #  module Refinery

