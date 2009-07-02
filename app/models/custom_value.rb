class CustomValue < ActiveRecord::Base  
    belongs_to :custom_field


    # Returns true if the boolean custom value is true
    def true?
      self.value == '1'
    end

    def required?
      custom_field.is_required?
    end

    def to_s
      value.to_s
    end

  protected
 
end
