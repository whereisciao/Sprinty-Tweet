class SprintADPController < ApplicationController
  def get_phone_list
    apiKey = params[:key]
    list = SprintADP.get_phone_list(apiKey)
    render :json => list
  end
end