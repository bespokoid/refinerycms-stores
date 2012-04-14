# *******************************************************************
#       t.references :product, :null => false
#       t.string    :download_token, :unique => true, :null => false
#       t.integer   :download_completed, :default => 0
#       t.integer   :download_remaining, :default => 0
#       t.integer   :download_count,     :default => 0
#       t.integer   :restrict_count
#       t.integer   :restrict_days
#       t.boolean   :is_defunct,         :default => false
#       t.string    :doc_file_name
#       t.string    :doc_content_type
#       t.integer   :doc_file_size
#       t.datetime  :doc_updated_at
#       t.string    :preview_file_name
#       t.string    :preview_content_type
#       t.integer   :preview_file_size
#       t.datetime  :preview_updated_at
# *******************************************************************
module Refinery
  module Products
    class Digidownload < Refinery::Core::BaseModel
      self.table_name = :refinery_digidownloads    

      has_attached_file :doc,
          :storage => :s3, 
          :s3_credentials => "#{Rails.root}/config/s3.yml", 
          :s3_protocol => "https",
          #  :s3_permissions => :private,
          :path => "/:style/downloads/:filename"

      has_attached_file :preview,
          :storage => :s3, 
          :s3_credentials => "#{Rails.root}/config/s3.yml", 
          :s3_protocol => "https",
          :path => "/:style/previews/:filename"


      belongs_to :product, :class_name => ::Refinery::Products::Product
      has_one    :line_item, :through => :product, :source => :line_items, :class_name => ::Refinery::Orders::LineItem
      has_one    :order, :through => :line_item, :class_name => ::Refinery::Orders::Order
      has_one    :user, :through => :order, :class_name => ::Refinery::User

      before_create  :generate_download_token
      before_save    :clean_restrictions

# #########################################################################
  
  @@icon_hash = nil
  
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
#  need accessor functions which look at restrict_count and/or restrict_date
#  to determine if it's okay to download
#  also to verify the token
# ------------------------------------------------------------------------------
# icon_hash= -- resets the icon hash to another set of image files
# ------------------------------------------------------------------------------
  def self.icon_hash=(icon_hash)
    @@icon_hash = icon_hash
  end
  
# ------------------------------------------------------------------------------
# icon_hash -- returns the icon hash; inits if first time
# ------------------------------------------------------------------------------
  def self.icon_hash()
    @@icon_hash ||= {
      :powerpoint    => "PowerPoint.png",
      :excel      => "Excel.png",
      :word       => "Word.png",
      :pdf        => "pdf-icon.png",
      :zip        => "zip_thumb.png",
      :text       => "muku-doc-font-128.png",
      :audio      => "audio-icon.png",
      :video      => "video-icon.png",
      :image      => "camera-icon.png",
      :html       => "html-icon.png",
        
      :unknown    => "warning-icon.png"
    }
  end
  
# ------------------------------------------------------------------------------
# category_to_icon -- returns an icon image name for a given category
# args:
#   category -- symbol for category
# ------------------------------------------------------------------------------
  def self.category_to_icon(category)
    return icon_hash[category] || icon_hash[:unknown]
  end
  
# ------------------------------------------------------------------------------
# to_category -- returns a category type (symbol) for the content-type
# args:
#   content_type -- string in standard MIME type
# ------------------------------------------------------------------------------
  def self.to_category(content_type)
    
    return :unknown if content_type.blank?
    
    tokens = content_type.split("/")
    category = tokens[0].to_sym
    if category == :application
      case tokens[1]
        when /ms-excel|spreadsheet/            then category = :excel
        when /ms-?word|wordprocessing/         then category = :word
        when /ms-powerpoint|presentation/      then category = :powerpoint
        when /wordperfect/    then category = :word
        when /pdf/            then category = :pdf
        when /zip/            then category = :zip
      else
        category = :unknown
      end  # case
    elsif category == :text
      case tokens[1]
        when /html/       then category = :html
      end  # case
    end   # application or text handling
      
    return category
  end
  
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
  def digi_select_list
    return ::Refinery::Products::Product.digi_select_list if self.product.nil?
    return [ ["no product selected",nil], [self.product.name, self.product_id] ]
  end

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
  def to_category()
    Digidownload.to_category(self.doc_content_type)
  end
  
# ------------------------------------------------------------------------------
  # to_player -- returns audio/video html if playable media
# ------------------------------------------------------------------------------
  def to_player()
   case to_category
     when :audio then "<audio src='#{self.doc.url}' controls preload='auto' autobuffer></audio>"
     when :video then "<video src='#{self.doc.url}' controls autobuffer></video>"
   else
     ""    # returns nothing
   end  # case
  end

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
  def generate_download_token
    self.download_token = ::Refinery::AuthKey.make_token
  end

# ------------------------------------------------------------------------------
  # clean_restrictions -- always ensure that restrictions are valid
# ------------------------------------------------------------------------------
  def clean_restrictions
    self.restrict_count = nil unless self.restrict_count.nil? || self.restrict_count > 0
    self.restrict_days  = nil unless self.restrict_days.nil?  || self.restrict_days > 0
  end

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------


# #########################################################################
 
    end   # class
  end   # mod
end   # mod
