# *******************************************************************
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
          :path => "/:style/:filename"

      has_attached_file :preview,
          :storage => :s3, 
          :s3_credentials => "#{Rails.root}/config/s3.yml", 
          :s3_protocol => "https",
          :path => "/:style/:filename"


      belongs_to :product, :class_name => '::Refinery::Products::Product'
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
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
  
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
  
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
  def to_category()
    Digidownload.to_category(self.doc_content_type)
  end
  
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
  
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

# #########################################################################
 
    end   # class
  end   # mod
end   # mod
