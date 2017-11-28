# further requires (models, helpers, core extensions etc. { but not 'middleware' because that should be grabbed up by Rack when appropriate })
Dir.glob('./application/**/*.rb') do |file|
  require file.gsub(/\.rb/, '') unless file.include?('middleware')
end

require 'pp'
require 'mysql2'
require 'json'
require 'date'

# -------------------------------------------------------------------

PROXY_SECRET='78f0e54616f32265e66c6e74401b7eced1ee7cb4'
API_PROGRAM_NO='783321' #global sales conf

#test/dev credentials
#API_USERNAME=''
#API_PASSWORD=''

#production credentials
#API_USERNAME='mobileadp2012'
#API_PASSWORD='h3TjqYQNF5'

get '/' do 

	puts "testing"
	get_api_token()
end


#authenticate a conference attendee's login credentials
get '/authenticateattendee' do
	#puts 'authenticateattendee route'

	proxy_secret = params['proxy_secret']
	callback = params['callback']
	user_name = params['user_name']
	user_pass = params['user_pass']
	
	get_proxy_secret= params['proxy_secret']
	
	begin
		if (get_proxy_secret == PROXY_SECRET) then
		
			api_token = get_api_token()
			
			client = Savon::Client.new do
				http.auth.ssl.verify_mode = :none
# 		  		wsdl.document = "https://test.travelhq.com/externalservices-ws/RegistrationInfoService?wsdl"
		  		wsdl.document = "https://www.travelhq.com/externalservices-ws/RegistrationInfoService?wsdl"
			end
		
				
			response = client.request "RetrieveAttendeeByRvs" do
				soap.xml="
				<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ext=\"http://www.travelhq.com/externalservices\">
		   <soapenv:Header/>
		   <soapenv:Body>
		      <ext:RetrieveAttendeeByRvs>
		         <!--Optional:-->
		         <arg0>#{api_token}</arg0>
		         <arg1>#{API_PROGRAM_NO}</arg1>
		         <!--Optional:-->
		         <arg2>#{user_name}</arg2>
		         <!--Optional:-->
		         <arg3>#{user_pass}</arg3>
		      </ext:RetrieveAttendeeByRvs>
		   </soapenv:Body>
		</soapenv:Envelope>"
		
			end
			
			#puts response.to_hash
				
			attendee_response = response.to_hash[:retrieve_attendee_by_rvs_response][:return]
		
			attendee= {}
			attendee[:attendee_id] = attendee_response[:attendee_id]
			attendee[:first_name] = attendee_response[:first_name]
			attendee[:last_name] = attendee_response[:last_name]
	
			if (attendee_response !=nil) then
				#append username and datetime to log
				File.open("./access_log.csv", "a") do |logfile|
					currdate = Time.now
					logfile.syswrite("\"#{attendee[:attendee_id]}\",\"#{user_name}\",\"#{currdate}\"\n")				
				end		
				
				"#{callback}({\"attendee\":#{attendee.to_json}})"
			else
				"#{callback}({})"
			end
						
		else
			html_page("Access Denied","")
		end
	
	rescue
		"#{callback}({})"
	end
	
end




def html_page(title, body)
    "<html>" +
        "<head><title>#{h title}</title></head>" +
        "<body><h1>#{h title}</h1>#{body}</body>" +
    "</html>"
end

helpers do
    include Rack::Utils
    alias_method :h, :escape_html
end

