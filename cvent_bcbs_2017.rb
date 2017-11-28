#BCBS integration
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
Cvent::Client.instance.load_config("#{File.dirname(__FILE__)}/config/cvent_credentials_bcbs.yml", 'production')

#check for Registration object. This call does not return data.
#code located in ./vendor/cvent-ruby/cvent/registration.rb
Cvent::Registration.find_for_event('502544b9-975a-4e31-ac26-f8c347da255a')
