module Refinery
  module Products
    class DigidownloadsController <  ::Refinery::StoresApplicationController

      helper  'refinery/stores/stores'

      def index
        @digidownloads = current_refinery_user.digidownloads
        present(@page)
      end

      def show
        @digidownload = ::Refinery::Products::Digidownload.find( params[:id] )
        # TODO: verify that digid belongs to customer
        present(@page)
      end

    protected

    end
  end
end
