require 'rubygems'
require 'httparty'
require 'mash'
class SprintADP
  def self.get_location(apiKey, mdn)
    sprint_resource = "http://sprintdevelopersandbox.com/devSandbox/resources/location.json?"
    query_string = "key=#{apiKey}&mdn=#{mdn}"    
    response = HTTParty.get(sprint_resource + query_string, :format => :json)    
    Mash.new(response)
  end
  def self.get_phone_list(apiKey)
    sprint_resource = "http://sprintdevelopersandbox.com/SandboxWS/resources/phones.json?"
    query_string = "key=#{apiKey}&authorized=a"    
    response = HTTParty.get(sprint_resource + query_string, :format => :json)    
    Mash.new(response)    
  end
end
