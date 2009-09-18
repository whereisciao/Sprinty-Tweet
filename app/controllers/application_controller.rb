# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Twitter::AuthenticationHelpers

  helper :all
  protect_from_forgery
  filter_parameter_logging :password, :password_confirmation

  rescue_from Twitter::Unauthorized, :with => :force_sign_in

  def load_sprint_settings
    @user = current_user
    @sprintSettings = Mash.new({
      :apiKey => @user.sprint_api_key,
      :mdn => format_mdn(@user.sprint_mdn)})

    if(@user.sprint_mdn && @user.sprint_api_key)
      begin
        phones = SprintADP.get_phone_list(@user.sprint_api_key).phone
      rescue
        phone = nil
      end
      if(phones)
        @sprintSettings.phones = phones.collect {|p| format_mdn(p)}
      else
        @sprintSettings.phones = []
        flash[:error] = 'Unable to load phone list.'
      end
    end
  end

  private
    def force_sign_in(exception)
      reset_session
      flash[:error] = 'Seems your credentials are not good anymore. Please sign in again.'
      redirect_to new_session_path
    end

    def format_mdn(mdn)
      if(mdn)
        " #{mdn.slice(0,3)}-#{mdn.slice(4,3)}-#{mdn.slice(6,4)}"
      end
    end
end
