#Fiserv integration
Dir.glob('./application/**/*.rb') do |file|
  require file.gsub(/\.rb/, '') unless file.include?('middleware')
end

require 'pp'
require 'mysql2'
require 'json'
require 'date'
require 'net/http'
require 'open-uri'
require 'sinatra/cross_origin'
require 'sinatra/reloader' #if development?
require 'sinatra/activerecord'
require 'yaml'

require_relative './models/models.rb'

#cvent-ruby vendor library
require "./vendor/cvent-ruby/lib/cvent.rb"

#login to the api. This call is working
#code located in ./vendor/cvent-ruby/lib/cvent/client.rb
Cvent::Client.instance.load_config("#{File.dirname(__FILE__)}/config/cvent_credentials_fiserv.yml", 'production')


#check for Registration object. This call is not working.
#code located in ./vendor/cvent-ruby/cvent/registration.rb
Cvent::Registration.find_for_event('b0246ce1-5306-49a2-b2fd-e46c70fa7db4')
