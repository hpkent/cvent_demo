require 'singleton'

module Cvent
  class Client
    include Singleton

    attr_accessor :server_url
    attr_accessor :cvent_session_header

    def load_config(file_path, environment=:default)
      @@client_configuration = YAML::load(File.open(file_path))
      @@environment = environment.to_s
      @@connected = nil
    end

    def connect
      raise Cvent::MissingCredentialsError.new("You must provide a config file by calling 'load_config' before connecting.") if @@client_configuration.nil?

      begin
        @@client = ::Savon.client(wsdl: Cvent::WSDL_PATH, ssl_version: :TLSv1)
        message = {
          "AccountNumber" => @@client_configuration[@@environment]["account"],
          "UserName" => @@client_configuration[@@environment]["username"],
          "Password" => @@client_configuration[@@environment]["password"]
        }
        response = self.call(:login, message)
        process_response(response)
        @@connected = Time.now
        return true
      rescue => e
        raise Cvent::ConnectionFailureError.new("Unable to connect to Cvent API: #{e.message}")
      end
    end

    def call(method, message={})
      self.connect unless method == :login || @@connected

      @@client.call(method, message: message)
    end

    private

    def process_response(response)
      if (response.body[:login_response] && response.body[:login_response][:login_result] && response.body[:login_response][:login_result][:@login_success] == "true")
        self.server_url = response.body[:login_response][:login_result][:@server_url]
        self.cvent_session_header = response.body[:login_response][:login_result][:@cvent_session_header]
        @@client = ::Savon.client(
          wsdl: Cvent::WSDL_PATH,
          endpoint: self.server_url,
          ssl_version: :TLSv1,
          soap_header: {
            "tns:CventSessionHeader" => { "tns:CventSessionValue" => self.cvent_session_header }
          }
        )
      else
        raise Cvent::ConnectionFailureError.new("Cvent rejected the API connection")
      end
    end
  end
end
