class SessionsController < ApplicationController  
  def new
  end
  
  def create
    oauth.set_callback_url(finalize_session_url)
    
    session['oauth_token']  = oauth.request_token.token
    session['oauth_verifier'] = oauth.request_token.secret
    
    redirect_to oauth.request_token.authorize_url
  end
  
  def destroy
    reset_session
    redirect_to new_session_path
  end
  
  def finalize
    oauth.authorize_from_request(session['oauth_token'], session['oauth_verifier'], params[:oauth_verifier])
    
    session['oauth_token']  = nil
    session['oauth_verifier'] = nil
    
    profile = Twitter::Base.new(oauth).verify_credentials
    user    = User.find_or_create_by_screen_name(profile.screen_name)
    
    user.update_attributes({
      :atoken => oauth.access_token.token, 
      :asecret => oauth.access_token.secret,
    })
    
    sign_in(user)
    redirect_back_or root_path
  end
  
  private
    def oauth
      @oauth ||= Twitter::OAuth.new(ConsumerConfig['token'], ConsumerConfig['secret'], :sign_in => true)
    end
end
