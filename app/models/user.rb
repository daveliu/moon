class User < ActiveRecord::Base
    acts_as_authentic     
    
    has_many :messages, :class_name => "Message", :foreign_key => "creator_id"
end
