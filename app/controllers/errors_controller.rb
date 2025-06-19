class ErrorsController < ApplicationController
  def show
    @error_title = flash[:error_title] || "Something Went Wrong"
    @error_message = flash[:error_message] || "Please try again later."
    render 'errors/show', layout: 'application'
  end
end
