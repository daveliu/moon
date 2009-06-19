class Message < ActiveRecord::Base
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  belongs_to :category, :class_name => "Category", :foreign_key => "category_id"
  
  has_many :comments, :as => :commentable, :dependent => :destroy, :order => 'created_at ASC'
  
  validates_presence_of :title, :body
end
