class MainPageController < ApplicationController
  def index
    if !user_signed_in?
      redirect_to new_user_session_path , alert: "Please sign in to continue"
    elsif ( current_user.role == "developer" || current_user.role == "qa")
        redirect_to projects_path
    end
  end
end
