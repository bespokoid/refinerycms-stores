module Refinery
  module Orders
# #########################################################################
    class OrderProcessingException < SecurityError; end
# #########################################################################
# #########################################################################
# #########################################################################
    class Order < Refinery::Core::BaseModel

      require 'aasm'
    
      self.table_name = :refinery_orders    

      has_many  :addresses, :class_name => ::Refinery::Addresses::Address
      has_many  :line_items
      has_many  :products, :through => :line_items, :class_name => ::Refinery::Products::Product
      has_many  :digidownloads, :through => :products, :class_name => ::Refinery::Products::Digidownload

      belongs_to :customer, :class_name => ::Refinery::Customers::Customer, :foreign_key => :order_customer_id
      belongs_to :user,     :class_name => ::Refinery::User, :foreign_key => :order_customer_id

      # belongs_to :shipping_type
      # belongs_to :discount
      # belongs_to :shipping_vendor

      before_create  :generate_order_number

      has_one   :billing_address, :class_name => ::Refinery::Addresses::Address,
         :conditions => { :is_billing => true }

      has_one   :shipping_address, :class_name => ::Refinery::Addresses::Address,
         :conditions => { :is_billing => false }

# #########################################################################
      #  attr_protected :order_number
      attr_accessible :order_notes, :shipping_type
# #########################################################################

#       t.integer       :order_number, :null => false, :unique => true
#       t.references    :order_customer
#       t.string        :order_status, :default => '', :null => false
#       t.text          :order_notes
#       t.references :shipping_type
#       t.datetime :shipped_on
#       t.float :product_total, :default => 0.0, :limit => 10
#       t.float :shipping_charges, :default => 0.0, :limit => 10
#       t.float :tax_charges, :default => 0.0, :limit => 5
#       t.string :cc_token
#       t.string :cc_last4, :limit => 8
#       t.string :cc_card_type, :limit => 32
#       t.integer :cc_expiry_month
#       t.integer :cc_expiry_year
#       t.datetime :cc_purchased_on
#       t.string  :cc_confirmation_id
#       t.boolean :has_digidownloads, :default => false
#       t.boolean :has_registrations, :default => false
#
# #########################################################################
# AASM STATE MACHINE AREA ... try to keep generic!
# #########################################################################

  include AASM

# #########################################################################
# STATE MACHINE STATES
# #########################################################################
  aasm_column :order_status   # expects this field for persistance of state
  
     # default starting state for order objects
  aasm_initial_state  :checkout_started
      
      # initial state: cart becomes an "empty" order (nothing else filled in)
  aasm_state  :checkout_started
       
    #  1 order processing states
  aasm_state  :edit_stage_completed,           :enter => :edit_done

    # 2 automatic states for purchased
  aasm_state  :purchase_confirmed,             :enter => :order_confirmed
  aasm_state  :order_completed,                :enter => :order_completed

    # 2 defunct or cancelled states
  aasm_state  :refunded_defunct,               :enter => :refund2defunct
  
# #########################################################################
# STATE MACHINE EVENT HANDLING
# #########################################################################        
#     
#   Further note:
#     if all digital download, skip delivery method
#     if all digital download && gateway_handles_billing, skip address
#     if gateway_does_everything, skip payment selection
#
# ---------------------------------------------------------------------------
  # next_in_process -- advances order thru order wizard stages
# ---------------------------------------------------------------------------
  aasm_event :next_in_process do
    transitions :to => :edit_stage_completed,   :from => :checkout_started
  end
  
# ---------------------------------------------------------------------------
  # confirm_purchase -- user definitely confirms purchase intent
# ---------------------------------------------------------------------------
  aasm_event :confirm_purchase do
    transitions :to => :purchase_confirmed, :from => :edit_stage_completed
  end
  
# ---------------------------------------------------------------------------
  # payment_verfified -- payment gateway verifies funds transfer
# ---------------------------------------------------------------------------
  aasm_event :payment_verified do
    transitions :to => :order_completed,    :from => :purchase_confirmed
  end
  
# ---------------------------------------------------------------------------
  # purchase_failed -- payment gateway failed
  # backs state to select a payment method
# ---------------------------------------------------------------------------
  aasm_event( :purchase_failed, :success => :void_payment ) do
    transitions :to => :delivery_stage_completed, :from => :purchase_confirmed
  end
     
# ---------------------------------------------------------------------------
  # refund_order -- order fully refunded making it defunct
# ---------------------------------------------------------------------------
  aasm_event :refund_order do
    transitions :to => :refunded_defunct, :from => :order_completed
  end
  
  
# ---------------------------------------------------------------------------
  # restart_checkout -- return to the edit stage
# ---------------------------------------------------------------------------
  aasm_event :restart_checkout  do
    transitions :to => :checkout_started,  
                :from => [:checkout_started, :edit_stage_completed, 
                          :purchase_confirmed ]
  end

# ---------------------------------------------------------------------------
  # cancel_process -- cancel the order wizard process, void any payt tokens
# ---------------------------------------------------------------------------
  aasm_event( :cancel_process, :success => :void_payment )  do
    transitions :to => :checkout_started,  
                :from => [:checkout_started, :edit_stage_completed ]
  end
    
# #########################################################################
# #########################################################################
# END OF AASM AREA
# #########################################################################
# #########################################################################

# ---------------------------------------------------------------------------
  #  get_render_template -- returns template name for next edit render
  #  returns nil if an invalid state
# ---------------------------------------------------------------------------
  def get_render_template
    action = {
      :checkout_started            => :edit,
      :edit_stage_completed        => :confirmation
    }[ self.order_status.to_sym ]

  end
  
# ---------------------------------------------------------------------------
  #  handle_update -- handle user params for updating order
  #  returns bill_address, ship_address objects (or nil for both)
  #  which might have errors
# ---------------------------------------------------------------------------
  def handle_update( params )
     if checkout_started?
       bill_address, ship_address = 
         ::Refinery::Addresses::Address.update_addresses( self, params )
       next_in_process!  if  bill_address.errors.empty? && ship_address.errors.empty?
     end

     self.cc_token = params[:stripeToken]
     self.cc_last4 = params[:last4]
     self.cc_card_type = params[:card_type]
     self.cc_expiry_month = params[:expiry_month]
     self.cc_expiry_year = params[:expiry_year]
     self.save!


     return bill_address, ship_address
   end 

# ---------------------------------------------------------------------------
  # checkout! -- checkout converts the cart into a fledgling order
# ---------------------------------------------------------------------------
  def self.checkout!( cart, user )
    order = Order.new
    order.user = user

      # convert cart.items to order.line_items
    cart.items.each do | item |
      order.line_items.build(
          :product    => item.product,
          :quantity   => item.quantity,
          :unit_price => item.price
      )
    end  # do

    order.save!

    return order
  end

# TODO: convert customer's billing/shipping addresses to order addresses

# ---------------------------------------------------------------------------
# get_billship_addresses -- returns a billing and a shipping address
  # args: customer obj
  # tries to addresses first from order itself, then customer, else new
# ---------------------------------------------------------------------------
  def get_billship_addresses( customer )

    bill_address  = self.billing_address  || 
                    customer.billing_address || 
                    ::Refinery::Addresses::Address.new( :is_billing => true  )

      # ship needs to be populated from bill if no ship already present
    ship_address  = self.shipping_address || 
                    customer.shipping_address || 
                    ::Refinery::Addresses::Address.new( 
                      :first_name  =>     bill_address.first_name ,  
                      :last_name   =>     bill_address.last_name  ,  
                      :phone       =>     bill_address.phone      ,  
                      :email       =>     bill_address.email      ,  
                      :address1    =>     bill_address.address1   ,  
                      :address2    =>     bill_address.address2   ,  
                      :city        =>     bill_address.city       ,  
                      :state       =>     bill_address.state      ,  
                      :zip         =>     bill_address.zip        ,  
                      :country     =>     bill_address.country    ,  
                      :is_billing  =>     false
                    ) 

    return bill_address, ship_address
  end


# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------
  
  def total_items
    line_items.sum { |item| item.quantity }
  end
  
  
  def total_price
    line_items.sum { |item| item.unit_price * item.quantity }
  end


# ---------------------------------------------------------------------------
  # process_purchase -- charges CC for the purchase
  # returns nil if error (self.errors captures), or result JSON obj
# ---------------------------------------------------------------------------
  def process_purchase( store_gateway )
    raise OrderProcessingException unless self.purchase_confirmed?

    result = store_gateway.charge_purchase( 
        self.cc_token, 
        self.product_total + self.shipping_charges + self.tax_charges, 
        self, 
        self.billing_address.email
    )

    unless result.nil?  # unless there were errors ...
      self.cc_purchased_on = Time.now         # date of purchase
      self.cc_confirmation_id = result.id     # confirmation code
        # next step saves above changes IFF paid is true
      self.payment_verified! if result.paid   # state becomes paid & final
    end   # unless there were errors

    return result

  end

# ---------------------------------------------------------------------------
  # any_digidownloads? -- return T if an order has any digidownloads in it
# ---------------------------------------------------------------------------
  def any_digidownloads?()
    LineItem.has_digidownloads?( self.id )
  end

# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------
  def self.any_digidownloads?( user_id )
    where( :has_digidownloads => true, :order_customer_id => user_id ).count > 0
  end

# ---------------------------------------------------------------------------
  # display_date -- returns a date for displaying for order
# ---------------------------------------------------------------------------
   def display_date
      ( self.shipped_on || self.cc_purchased_on || self.updated_at ).to_date
   end

# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------


  private

# ---------------------------------------------------------------------------
  # edit_done -- things to do after edit input & verified
# ---------------------------------------------------------------------------
  def edit_done()
    
  end

# ---------------------------------------------------------------------------
  # order_confirmed -- things to do after user confirmed purchase decision
# ---------------------------------------------------------------------------
  def order_confirmed()
    self.product_total = total_price
    # shipping_charges
    # tax_charges
    save!
  end

# ---------------------------------------------------------------------------
  # order_completed -- things to do after purchase verified by gateway
# ---------------------------------------------------------------------------
  def order_completed()
    # create a confirmation code
    # kick off shipping process

    self.has_digidownloads = any_digidownloads? 
    save

  end

# ---------------------------------------------------------------------------
  # refund2defunct -- things to do after refunding an order making it defunct
# ---------------------------------------------------------------------------
  def refund2defunct()
  end

# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------
  def void_payment
    
  end

# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------
  def generate_order_number
    nbr = 0 
    max = 0x7ffffffe
    tries = max  # deadman counter to prevent infinite loop

    while ( tries > 0  &&  Order.find_by_order_number(nbr = rand( max ) + 1) ) do
      tries = tries - 1   # decrement deadman counter
    end   # while
    raise ArgumentError, "maxed out store order numbers?!" if tries.zero?

    self.order_number = nbr
  end

# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------
  
# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------
              
# #########################################################################
    end # class Order
# #########################################################################
  end # module Orders
end # module Refinery
