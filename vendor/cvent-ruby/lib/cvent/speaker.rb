module Cvent
  class Speaker
    OBJECT_TYPE = "Speaker"

    attr_accessor :id, :first_name, :last_name, :email_address, :prefix, :designation,
      :company, :speaker_code, :title, :event_id, :event_title, :event_code, :facebook_url,
      :linked_in_url, :twitter_url, :category_id, :category, :display_on_website, :profile_image_url,
      :biography, :internal_note, :created_date, :created_by, :last_modified_date, :last_modified_by

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
          return Cvent::Speaker.fetch_from_ids(ids)
        else
          return response.body
        end

      rescue => e
        return e
      end
    end

    def self.fetch_from_ids(speaker_ids=[])
      message = {
        "ObjectType" => self::OBJECT_TYPE,
        "ins0:Ids" => { "ins0:Id" => speaker_ids }
      }

      return [] if speaker_ids.empty?

      begin
        response = Cvent::Client.instance.call(:retrieve, message)

        if response.body && response.body[:retrieve_response] && response.body[:retrieve_response][:retrieve_result] && response.body[:retrieve_response][:retrieve_result][:cv_object]
          speakers = response.body[:retrieve_response][:retrieve_result][:cv_object]

          speakers = [speakers] if speakers.is_a? Hash

          speakers.collect { |s| self.transform_to_speaker_object(s) }
        else
          return []
        end
      rescue
        return []
      end
    end

    private

    def self.transform_to_speaker_object(speaker)
      s = Cvent::Speaker.new
      s.id = speaker[:@id]
      s.first_name = speaker[:@first_name]
      s.last_name = speaker[:@last_name]
      s.email_address = speaker[:@email_address]
      s.prefix = speaker[:@prefix]
      s.designation = speaker[:@designation]
      s.company = speaker[:@company]
      s.title = speaker[:@title]
      s.speaker_code = speaker[:@speaker_code]
      s.event_id = speaker[:@event_id]
      s.event_title = speaker[:@event_title]
      s.event_code = speaker[:@event_code]
      s.facebook_url = speaker[:@facebook_url]
      s.linked_in_url = speaker[:@linked_in_url]
      s.twitter_url = speaker[:@twitter_url]
      s.category_id = speaker[:@category_id]
      s.category = speaker[:@category]
      s.display_on_website = speaker[:@display_on_website]
      s.profile_image_url = speaker[:@profile_image_url]
      s.biography = speaker[:@biography]
      s.internal_note = speaker[:@internal_note]
      s.created_date = speaker[:@created_date]
      s.created_by = speaker[:@created_by]
      s.last_modified_date = speaker[:@last_modified_date]
      s.last_modified_by = speaker[:@last_modified_by]

      return s
    end
  end
end
