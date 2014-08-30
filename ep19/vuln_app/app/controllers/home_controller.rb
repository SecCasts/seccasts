class HomeController < ApplicationController
  
  before_filter :authenticated 
  
  def new
  end
end
