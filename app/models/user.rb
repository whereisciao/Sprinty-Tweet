# == Schema Information
#
# Table name: users
#
#  id          :integer(4)      not null, primary key
#  email       :string(255)
#  atoken      :string(255)
#  asecret     :string(255)
#  screen_name :string(30)
#

class User < ActiveRecord::Base
  attr_accessible :atoken, :asecret, :sprint_api_key, :sprint_mdn

  validates_presence_of :sprint_mdn, :unless => :api_key_not_present
  validates_format_of :sprint_mdn, :with => /\d{10}/, 
    :message => "needs to be 10 digits", :unless => :api_key_not_present

  def api_key_not_present
    self.sprint_api_key.nil? || self.sprint_api_key.blank?
  end
  
  def authorized?
    atoken.present? && asecret.present?
  end
  
  def oauth
    @oauth ||= Twitter::OAuth.new(ConsumerConfig['token'], ConsumerConfig['secret'])
  end
  
  delegate :request_token, :access_token, :authorize_from_request, :to => :oauth
  
  def client
    @client ||= begin
      oauth.authorize_from_access(atoken, asecret)
      Twitter::Base.new(oauth)
    end
  end
  
  def location_enabled?
    !sprint_api_key.nil? && !sprint_mdn.nil?
  end
end
