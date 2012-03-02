module Refinery
  class StoreGateway

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
      str << ": TEST MODE " if @gateway_mode == "test"
      return str
    end

# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------
    def purchase_description( billee )
      "purchase for " + billee.email.to_s
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
