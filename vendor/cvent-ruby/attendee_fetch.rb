require "#{File.dirname(__FILE__)}/lib/cvent.rb"
require 'json'

Cvent::Client.instance.load_config("#{File.dirname(__FILE__)}/../../config/cvent_credentials.yml", 'production')

#Cvent::Client.instance.connect

## Get listing of all events ##

# ids = Cvent::Event.get_updated_ids((DateTime.now - 30))
# puts ids.to_json

# events = Cvent::Event.fetch_from_ids(ids)

# events.each do |event|
# 	puts "#{event.title} : #{event.id}"
# 	# puts "#{event.start_date}: #{event.description}"
# end

## Get attendees for specific event ##
#2015 Blue National Summit : F4AFDCA1-60DC-4985-A6B4-42F6639FF811

registrants = Cvent::Registration.find_for_event("F4AFDCA1-60DC-4985-A6B4-42F6639FF811")
#puts registrants.length
attendees = []
registrants.each_with_index do |attendee,i|
	attendees << {}
	attendees[i]["first_name"] = attendee.first_name
	attendees[i]["last_name"] = attendee.last_name
	attendees[i]["title"] = attendee.title
	attendees[i]["email_address"] = attendee.email_address
	attendees[i]["work_postal_code"] = attendee.work_postal_code
	attendees[i]["registration_type"] = attendee.registration_type
	attendees[i]["account_code"] = attendee.id
	puts "#{i}|  #{attendee.id}:#{attendee.first_name} #{attendee.last_name} #{attendee.title} #{attendee.email_address} #{attendee.work_postal_code} #{attendee.registration_type}"

	#puts attendee.id
	# puts "#{i}|  #{attendee[:@first_name]} #{attendee[:@last_name]}"
	#puts attendee
end

puts attendees.to_json
