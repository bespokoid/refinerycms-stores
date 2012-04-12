module Refinery
  module Products
    class DigidownloadsController <  ::Refinery::StoresApplicationController

      helper  'refinery/stores/stores'

      def index
          present(@page)
       end

      def show
          present(@page)
       end

    protected

    end
  end
end
