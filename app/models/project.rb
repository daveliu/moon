class Project < ActiveRecord::Base
  has_many :milestones
  has_many :messages
  has_many :todo_lists
  has_many :assets
  has_many :timeline_events
  has_many :time_entries
end
