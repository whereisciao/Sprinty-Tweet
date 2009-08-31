# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def location_setup?
    current_user.location_enabled?
  end
end
