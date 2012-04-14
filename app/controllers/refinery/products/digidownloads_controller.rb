module Refinery
  module Products
    class DigidownloadsController <  ::Refinery::StoresApplicationController

      helper  'refinery/stores/stores'
      before_filter   :find_digidownload, :only => [:show, :download, :preview]

      def index
        @digidownloads = current_refinery_user.digidownloads
        present(@page)
      end

      def show
        present(@page)
      end

      def download
        redirect_to @digidownload.doc.expiring_url(60)  # temp authenticated url expires in 60 sec
      end

    protected

    def find_digidownload
        # TODO: verify that digid belongs to current user 
      @digidownload = ::Refinery::Products::Digidownload.find( params[:id] )
      return false unless refinery_user_signed_in? && current_refinery_user == @digidownload.user
    end


    end
  end
end
