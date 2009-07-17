class Message < ActiveRecord::Base   
  include Permissions
  
  default_scope :order => 'created_at DESC'
  
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  belongs_to :category, :class_name => "Category", :foreign_key => "category_id"
  belongs_to :project
  
  has_many :comments, :as => :commentable, :dependent => :destroy, :order => 'created_at ASC'
  has_many :assets, :as => :attachable,    :dependent => :destroy, :order => 'created_at ASC'
  
  has_many :notifies,  :as => :notifiable, :dependent => :destroy
  has_many :notify_users, :through => :notifies, :source => :user
  
  accepts_nested_attributes_for :assets                          
  accepts_nested_attributes_for :notifies
  
  validates_presence_of :title, :body                                                        
  
  fires :new_message, :on                 => :create,
                      :actor              => :creator    
                      
  def day
    self.created_at.to_date
  end                                      
  
  def last_comment
    comments.last
  end
                                                         
  #hard code!!!
  def code?
    category && category.name == "code"
  end
end
