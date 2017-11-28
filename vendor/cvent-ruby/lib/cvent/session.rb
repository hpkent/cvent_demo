module Cvent
  class Session
    OBJECT_TYPE = "Session"

    # attr_accessor :id, :first_name, :last_name, :email_address, :prefix, :designation,
    #   :company, :session_code, :title, :event_id, :event_title, :event_code, :facebook_url,
    #   :linked_in_url, :twitter_url, :category_id, :category, :display_on_website, :profile_image_url,
    #   :biography, :internal_note, :created_date, :created_by, :last_modified_date, :last_modified_by

    def self.find_for_event(event_id)
      message = {
        "ObjectType" => self::OBJECT_TYPE,
        "ins0:CvSearchObject" => {
          :attributes! => { "SearchType" => "AndSearch" },
          "ins0:Filter" => {
            "ins0:Field" => "EventId",
            "ins0:Operator" => "Equals",
            "ins0:Value" => event_id
          }
        }
      }
      begin
        response = Cvent::Client.instance.call(:search, message)

        if response.body && response.body[:search_response] && response.body[:search_response][:search_result] && response.body[:search_response][:search_result][:id]
          ids = response.body[:search_response][:search_result][:id]
          ids = [ids] if ids.is_a? String

          return Cvent::Session.fetch_from_ids(ids)
        else
          return response.body
        end
      rescue => e
        return e
      end
    end

    def self.fetch_from_ids(session_ids=[])
      puts "test2"
      message = {
        "ObjectType" => self::OBJECT_TYPE,
        "ins0:Ids" => { "ins0:Id" => session_ids }
      }

      return [] if session_ids.empty?

      begin
        response = Cvent::Client.instance.call(:retrieve, message)

        if response.body && response.body[:retrieve_response] && response.body[:retrieve_response][:retrieve_result] && response.body[:retrieve_response][:retrieve_result][:cv_object]
          sessions = response.body[:retrieve_response][:retrieve_result][:cv_object]

          sessions = [sessions] if sessions.is_a? Hash

          sessions.collect { |s| self.transform_to_session_object(s) }
        else
          return []
        end
      rescue
        return []
      end
    end

    private

    def self.transform_to_session_object(session)
      s = Cvent::Session.new
      s.id = session[:@id]
      s.first_name = session[:@first_name]
      s.last_name = session[:@last_name]
      s.email_address = session[:@email_address]
      s.prefix = session[:@prefix]
      s.designation = session[:@designation]
      s.company = session[:@company]
      s.title = session[:@title]
      s.session_code = session[:@session_code]
      s.event_id = session[:@event_id]
      s.event_title = session[:@event_title]
      s.event_code = session[:@event_code]
      s.facebook_url = session[:@facebook_url]
      s.linked_in_url = session[:@linked_in_url]
      s.twitter_url = session[:@twitter_url]
      s.category_id = session[:@category_id]
      s.category = session[:@category]
      s.display_on_website = session[:@display_on_website]
      s.profile_image_url = session[:@profile_image_url]
      s.biography = session[:@biography]
      s.internal_note = session[:@internal_note]
      s.created_date = session[:@created_date]
      s.created_by = session[:@created_by]
      s.last_modified_date = session[:@last_modified_date]
      s.last_modified_by = session[:@last_modified_by]

      return s
    end
  end
end
