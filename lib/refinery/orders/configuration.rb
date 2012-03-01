module Refinery
  module Orders
    include ActiveSupport::Configurable

    config_accessor :store_name, :cc_charge_description, 
                    :gateways, :gateway_mode, :gateway_secret, :gateway_public, :gateway_url

    self.store_name = "My Store"
    self.gateways = %w( stripe )
    self.gateway_mode = 'test'
    self.gateway_secret = "API secret key"
    self.gateway_public = "API public key"
    self.gateway_url    = "API url"

    def config.register_gateway(name)
      self.gateways << name
    end

    def self.clear_gateways!
      self.gateways = []
    end


  end  # module Orders
end  # module Refinery
