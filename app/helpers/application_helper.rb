module ApplicationHelper
  def auth?
    !(session[:uid].nil?)
  end
end
