module Refinery
  class StoreGateway

     require 'stripe'

# #########################################################################
# #########################################################################
# PAYMENT / GATEWAY CONFIGURATION
# #########################################################################
# #########################################################################

    attr_reader :gateway_mode, 
                :payment_access_url, :payment_secret_key, :payment_api_key

# #########################################################################
# #########################################################################
# ---------------------------------------------------------------------------
    # initialize -- creates new StoreGateway obj; 
    # args: store object
# ---------------------------------------------------------------------------
    def initialize( store )
      @store = store    # remember the store
      
      @gateways = %w( stripe )

      # TODO: make this variable by gateway type
      payment_gateway = "stripe"
      @gateway_mode =  ::Refinery::Setting.find_or_set( :payment_gateway_mode, "test" )
         # do some error checking & cleanup
      @gateway_mode = "test" unless @gateway_mode =~ /(test)|(live)/

      # setup the keys for the payment gateway
      payment_settings = "#{payment_gateway}_#{@gateway_mode}"

      @payment_access_url = ::Refinery::Setting.find_or_set( "#{payment_settings}_access_url".to_sym, "access URL missing" )
      @payment_secret_key = ::Refinery::Setting.find_or_set( "#{payment_settings}_secret_key".to_sym, "secret key missing" )
      @payment_api_key    = ::Refinery::Setting.find_or_set( "#{payment_settings}_api_key".to_sym,    "public API key missing" )
    end

# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------
    def store_name
      str = @store.name
      str << " [TEST MODE]" if @gateway_mode == "test"
      return str
    end

# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------
    def purchase_description( order_nbr, email )
      "#{store_name } Order: #{order_nbr.to_s} purchase for: #{email.to_s}"
    end

# ---------------------------------------------------------------------------
# charge_purchase -- charge customer card for purchase
    # args:
    #   token -- string for CC token produced earlier
    #   amount -- float amt for charge in dollars.cents
    #   order_nbr -- integer order number
    #   email -- customer email
# ---------------------------------------------------------------------------
    def charge_purchase( token, amount, order_nbr, email )
        # secret_key for Stripe
      Stripe.api_key = @payment_secret_key
 
        # create the charge on Stripe's servers
        # this will charge the user's card

      charge = Stripe::Charge.create(
        :amount => (amount * 100).to_i, # amount in cents
        :currency => "usd",             # US$
        :card => token,
        :description => purchase_description( order_nbr, email )
      )

    end

# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------
    def register_gateway(name)
      @gateways << name
    end

# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------
    def clear_gateways!
      @gateways = []
    end

# #########################################################################
# #########################################################################

  end  # class StoreGateway
end  # module Refinery
