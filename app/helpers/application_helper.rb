# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def location_setup?
    if signed_in?
      current_user.location_enabled?
    else
      false
    end
  end
end
