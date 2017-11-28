require "#{File.dirname(__FILE__)}/lib/cvent.rb"

Cvent::Client.instance.load_config("#{File.dirname(__FILE__)}/../../config/cvent_credentials.yml", 'production')

#ids = Cvent::Event.get_updated_ids((DateTime.now - 14))
#@response = Cvent::Event.fetch_from_ids(ids)
response = Cvent::Event.fetch_from_ids(["8338A8CF-2263-4D18-8409-D8264ADAD782"])
puts response
