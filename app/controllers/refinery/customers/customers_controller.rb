module Refinery
  module Customers
    class CustomersController < ApplicationController

      crudify :customer
      
      # Protect these actions behind customer login - do we need to check out not signing up when signed in?
      before_filter :redirect?, :except => [:new, :create]

      # GET /customer/:id
      def show
        @page = Page.find_by_link_url('/customer_show')
      end

      def new
        @customer = Customer.new
        @page = Page.find_by_link_url('/customers/new')
      end

      # GET /customers/:id/edit
      def edit
        @customer = get_customer(params[:id])
        @is_admin = is_admin?
        @page = Page.find_by_link_url('/customer_edit')
      end

      # PUT /customers/:id
      def update
        @customer = get_customer(params[:id])

        if params[:customer][:password].blank? and params[:customer][:password_confirmation].blank?
          params[:customer].delete(:password)
          params[:customer].delete(:password_confirmation)
        end

        # approve/reject - admin for non-customer only
        if is_admin?
          if params["admin"] && !@customer.is_customer?
            if params["admin"]["action"] == 'approve'
              accept_customer(@customer)
            elsif params["admin"]["action"] == 'reject'
              reject_customer(@customer) unless @customer.is_
            end
          end
        end

        params.delete("admin")

        # keep these the same
        params[:customer][:username] = params[:customer][:email]

        if @customer.update_attributes(params[:customer])
          flash[:notice] = t('successful', :scope => 'customers.update', :email => @customer.email)
          CustomershipMailer.profile_update_notification_admin(@customer).deliver unless is_admin?
          redirect_to(is_admin? ? admin_customerships_path : root_path )

        else
          @is_admin = is_admin?
          @page = Page.find_by_link_url('/customer_edit')
          render :action => 'edit'
        
        end
      end

      def create
        @customer = Customer.new(params[:customer])
        @customer.username = @customer.email
        @customer.customership_level = 'Customer'

        if @customer.save
          CustomershipMailer.application_confirmation_customer(@customer).deliver
          CustomershipMailer.application_confirmation_admin(@customer).deliver
          
          redirect_to(is_admin? ? admin_customerships_path : root_path )

        else
          @page = Page.find_by_link_url('/customers/new')
          @customer.errors.delete(:username) # this is set to email
          render :action => :new
          
        end

      end

      def searching?
        params[:search].present?
      end

      def index
        respond_to do |format|
          format.html{
            @page = Page.find_by_link_url('/customers')
          }
          format.js{
            @objects = current_objects(params)
            @total_objects = total_objects(params)
            render :layout => false
          }
        end
      end

      private

      def current_objects(params={})
        current_page = (params[:iDisplayStart].to_i/params[:iDisplayLength].to_i rescue 0)+1
        @current_objects = Customer.paginate :page => current_page,
          :include => [:roles],
          :order => "#{datatable_columns(params[:iSortCol_0])} #{params[:sSortDir_0] || "DESC"}",
          :conditions => conditions,
          :per_page => params[:iDisplayLength]
      end

      def total_objects(params={})
        all = Customer.count(:include => [:roles], :conditions => conditions)
        admins = Customer.count(:include => :roles, :conditions => "roles.id in (#{REFINERY_ROLE_ID},#{SUPERUSER_ROLE_ID})")
        @total_objects = all - admins
      end

      def datatable_columns(column_id)
        case column_id.to_i
        when 0
          return "last_name"
        when 1
          return "organization"
        when 2
          return "city"
        when 3
          return "province"
        when 4
          return "phone"
        when 5
          return "email"
        end

      end

      def conditions
        conditions = []

        unless params[:sSearch].blank?

          search = []
          %w(first_name last_name organization city province phone email).each{ |field|
            search << "#{field} LIKE '%#{params[:sSearch]}%'"
          }
          conditions << search.join(" OR ")
        end

        return conditions.join(" AND ")
      end

      def accept_customer(customer)
        customer.activate
        CustomershipMailer.acceptance_confirmation_customer(customer).deliver
        CustomershipMailer.acceptance_confirmation_admin(customer, refinery_current_user).deliver
      end

      def reject_customer(customer)
        customer.deactivate
        CustomershipMailer.rejection_confirmation_customer(customer).deliver
        CustomershipMailer.rejection_confirmation_admin(customer, refinery_current_user).deliver
      end

    protected
      def redirect?
        if refinery_current_user.nil?
          redirect_to new_user_session_path
        end
      end

      # unless you're an admin, you can only edit your profile
      def get_customer(id)
        is_admin? ?  Customer.find(id) : refinery_current_user
      end

      def is_admin?
        !(refinery_current_user.role_ids & [REFINERY_ROLE_ID, SUPERUSER_ROLE_ID]).empty?
      end

    end  #  class
  end #  module Customers
end #   module Refinery
