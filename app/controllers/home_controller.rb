class HomeController < ApplicationController
  def index
    @lates = Milestone.by_state("late")
    @upcomings = Milestone.by_state("upcoming")
    @events = TimelineEvent.all
  end
  
  private 
  def set_body_class
    @body_class = "overview"
  end
  
end
