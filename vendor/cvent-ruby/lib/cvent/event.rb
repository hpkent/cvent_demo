module Cvent
  class Event
    OBJECT_TYPE = "Event"

    attr_accessor :id, :title, :code, :start_date, :end_date, :launch_date, :timezone, :description, :internal_note, :status, :capacity, :category, :meeting_request_id, :currency, :planning_status, :location, :street_address1, :street_address2, :street_address3, :city, :state, :state_code, :postal_code, :country, :country_code, :phone_number, :planner_first_name, :planner_last_name, :planner_email_address, :last_date_modified, :rsvp_by_date, :archive_date, :closed_by, :external_auth, :hidden
    attr_accessor :speakers
    attr_accessor :links
    attr_accessor :custom_fields

    def initialize
      self.links = []
      self.speakers = []
      self.custom_fields = []
    end

    def self.get_updated_ids(start_date= DateTime.now-5, end_date = DateTime.now)
      @start_date = start_date
      @end_date = end_date
      message = {
        "ObjectType" => self::OBJECT_TYPE,
        "StartDate" => start_date.strftime("%Y-%m-%dT%H:%M:%S"),
        "EndDate" => end_date.strftime("%Y-%m-%dT%H:%M:%S")
      }
      begin
        response = Cvent::Client.instance.call(:get_updated, message)
        if response && response.body[:get_updated_response] && response.body[:get_updated_response][:get_updated_result]
          ids = response.body[:get_updated_response][:get_updated_result][:id]
          self.fetch_from_ids(ids)
        else
          return []
        end
      rescue
        return []
      end
    end

    def self.fetch_from_ids(event_ids=[])
      message = {
        "ObjectType" => self::OBJECT_TYPE,
        "ins0:Ids" => { "ins0:Id" => event_ids }
      }

      return [] if event_ids.empty?

      begin
        response = Cvent::Client.instance.call(:retrieve, message)

        if response.body && response.body[:retrieve_response] && response.body[:retrieve_response][:retrieve_result] && response.body[:retrieve_response][:retrieve_result][:cv_object]
          cvent_events = response.body[:retrieve_response][:retrieve_result][:cv_object]

          cvent_events = [cvent_events] if cvent_events.is_a? Hash

          return cvent_events.collect { |e| self.transform_to_event_object(e) }

        end
      rescue => e
        return []
      end
    end

    private

    def self.transform_to_event_object(cvent_event)
      e = Cvent::Event.new
      e.id = cvent_event[:@id]
      e.title = cvent_event[:@event_title]
      e.code = cvent_event[:@event_code]
      e.start_date = cvent_event[:@event_start_date]
      e.end_date = cvent_event[:@event_end_date]
      e.launch_date = cvent_event[:@event_launch_date]
      e.timezone = cvent_event[:@timezone]
      e.description = cvent_event[:@event_description]
      e.internal_note = cvent_event[:@internal_note]
      e.status = cvent_event[:@event_status]
      e.capacity = cvent_event[:@capacity]
      e.category = cvent_event[:@category]
      e.meeting_request_id = cvent_event[:@meeting_request_id]
      e.currency = cvent_event[:@currency]
      e.planning_status = cvent_event[:@planning_status]
      e.location = cvent_event[:@location]
      e.street_address1 = cvent_event[:@street_address1]
      e.street_address2 = cvent_event[:@street_address2]
      e.street_address3 = cvent_event[:@street_address3]
      e.city = cvent_event[:@city]
      e.state = cvent_event[:@state]
      e.state_code = cvent_event[:@state_code]
      e.postal_code = cvent_event[:@postal_code]
      e.country = cvent_event[:@country]
      e.country_code = cvent_event[:@country_code]
      e.phone_number = cvent_event[:@phone_number]
      e.planner_first_name = cvent_event[:@planner_first_name]
      e.planner_last_name = cvent_event[:@planner_last_name]
      e.planner_email_address = cvent_event[:@planner_email_address]
      e.last_date_modified = cvent_event[:@last_modified_date]
      e.rsvp_by_date = cvent_event[:@rsv_pby_date]
      e.archive_date = cvent_event[:@archive_date]
      e.closed_by = cvent_event[:@closed_by]
      e.external_auth = cvent_event[:@external_authentication]
      e.hidden = cvent_event[:@hidden]

      if cvent_event[:weblink_detail]
        cvent_event[:weblink_detail].each do |link|
          e.links << Cvent::Link.create_from_hash(link)
        end
      end

      if cvent_event[:custom_field_detail]
        cvent_event[:custom_field_detail].each do |field|
          e.custom_fields << Cvent::CustomField.create_from_hash(field)
        end
      end

      e.speakers = Cvent::Speaker.find_for_event(e.id)

      return e
    end
  end
end
