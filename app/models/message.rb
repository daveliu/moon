class Message < ActiveRecord::Base
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  belongs_to :category, :class_name => "Category", :foreign_key => "category_id"
  
  has_many :comments, :as => :commentable, :dependent => :destroy, :order => 'created_at ASC'
  has_many :assets, :as => :attachable,    :dependent => :destroy, :order => 'created_at ASC'
  
  accepts_nested_attributes_for :assets
  
  validates_presence_of :title, :body                                                        
  
  fires :new_message, :on                 => :create,
                      :actor              => :creator
end
