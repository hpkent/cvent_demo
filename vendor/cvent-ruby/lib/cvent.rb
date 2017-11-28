require 'httparty'
require 'yaml'
require 'savon'

Dir[File.dirname(__FILE__) + '/cvent/**/*.rb'].each do |file|
    require file
end

module Cvent
  AUTHENTICATION_URL = "http://www.cvent.com/Events/APIs/Reg.aspx"
  WSDL_PATH = "https://api.cvent.com/soap/V200611.ASMX?WSDL"
end
