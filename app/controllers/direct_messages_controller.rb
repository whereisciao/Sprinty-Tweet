class DirectMessagesController < ApplicationController
  before_filter :authenticate, :load_sprint_settings
  
  def index
    params[:page] ||= 1
    @direct_messages = current_user.client.direct_messages(:page => params[:page])
  end
end
