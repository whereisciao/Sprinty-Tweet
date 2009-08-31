# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'twitter', :version => '0.6.15'  
  config.time_zone = 'UTC'
  config.gem 'mash', '0.0.3'
  config.gem 'httparty', '0.4.3' 
end

module SprintADP
  def self.get_location(apiKey, mdn)
    sprint_resource = "http://sprintdevelopersandbox.com/devSandbox/resources/location.json?"
    query_string = "key=#{apiKey}&mdn=#{mdn}"    
    response = HTTParty.get(sprint_resource + query_string, :format => :json)    
    Mash.new(response)
  end
end

ConsumerConfig = YAML.load(File.read(Rails.root + 'config' + 'consumer.yml'))