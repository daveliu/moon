class CustomField < ActiveRecord::Base
  has_many :custom_values, :dependent => :delete_all
  

  FIELD_FORMATS = %w[string text]

  validates_presence_of :name, :field_format     
  
  def value_for(response)
    response.custom_values.find(:first  , :conditions => ["custom_field_id = ?", self.id]).value
  end  
  
  
end
