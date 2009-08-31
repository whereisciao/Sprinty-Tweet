class UsersController < ApplicationController
  before_filter :authenticate
  
  def show
    @tweets = current_user.client.user_timeline(:id => params[:id])
    @user = current_user.client.user(params[:id])
  end

  def setup_sprint
    @user = current_user
    @user.sprint_api_key = params[:apiKey] || ""
    @user.sprint_mdn = params[:mdn] || ""
    if(@user.save)
      flash[:notice] = "Sprint API Settings Saved.<br/>You're a go to send out a Location-Tagged Tweet!"
    else
      flash[:notice] = "Oops. The settings did not save. How about trying it one more time?"      
    end
    return_to_or root_url
  end
  
end