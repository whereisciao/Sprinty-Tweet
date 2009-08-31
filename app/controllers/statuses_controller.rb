class StatusesController < ApplicationController
  before_filter :authenticate
  
  def index
    params[:page] ||= 1
    @tweets = current_user.client.friends_timeline(:page => params[:page])
  end
  
  def show
    @tweet = current_user.client.status(params[:id])
  end
  
  def mentions
    params[:page] ||= 1
    @mentions = current_user.client.replies(:page => params[:page])
  end
  
  def favorites
    params[:page] ||= 1
    @favorites = current_user.client.favorites(:page => params[:page])
  end
  
  def create
    options = {}
    
    unless params[:in_reply_to_status_id].blank?
      options.merge!({:in_reply_to_status_id => params[:in_reply_to_status_id]})
    end

    tweet = current_user.client.update(params[:text], options)
    flash[:notice] = "Got it! Tweet ##{tweet.id} created."
    if(current_user.location_enabled?)
      response = SprintADP.get_location(current_user.sprint_api_key, current_user.sprint_mdn)
      if(response.error.nil?)
        location = "Sprint (#{response.lat}, #{response.lon})"
        current_user.client.update_profile(:location => location.slice(0..29))
        flash[:notice].gsub!(".", ",")
        flash[:notice] += " and Profile Location updated."
      else
        flash[:notice] += " But I had trouble locating you." 
      end
    end
    return_to_or root_url
  end
  
  def fav
    flash[:notice] = "Tweet fav'd. May not show up right away due to API latency."
    current_user.client.favorite_create(params[:id])
    return_to_or root_url
  end
  
  def unfav
    flash[:notice] = "Tweet unfav'd. May not show up right away due to API latency."
    current_user.client.favorite_destroy(params[:id])
    return_to_or root_url
  end
end
