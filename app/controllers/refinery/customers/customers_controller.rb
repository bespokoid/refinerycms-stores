module Refinery
  module Customers
    class CustomersController < ApplicationController

        CUSTOMER_ROLE_ID  = 4
        MEMBER_ROLE_ID    = 3
        REFINERY_ROLE_ID  = 2
        SUPERUSER_ROLE_ID = 1

      crudify :customer
      
      # Protect these actions behind customer login - do we need to check out not signing up when signed in?
      before_filter :redirect?, :except => [:new, :create]

      def new
        @customer = Customer.new
      end

      # GET /customers/:id/edit
      def edit
        @customer = get_customer(params[:id])
        @is_admin = is_admin?
      end

      # PUT /customers/:id
      def update
        @customer = get_customer(params[:id])

        if params[:customer][:password].blank? and params[:customer][:password_confirmation].blank?
          params[:customer].delete(:password)
          params[:customer].delete(:password_confirmation)
        end

        # keep these the same
        params[:customer][:username] = params[:customer][:email]

        if @customer.update_attributes(params[:customer])
          flash[:notice] = t('successful', :scope => 'customers.update', :email => @customer.email)
          redirect_to root_path 

        else
          render :action => 'edit'
        end

      end

      def create
        @customer = Customer.new(params[:customer])
        @customer.username = @customer.email
        @customer.customership_level = 'Customer'

        if @customer.save
          
          redirect_to root_path 

        else
          @customer.errors.delete(:username) # this is set to email
          render :action => :new
          
        end

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
