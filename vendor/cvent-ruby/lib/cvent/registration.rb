module Cvent
  class Registration
    OBJECT_TYPE = "Registration"

    attr_accessor :id, :contact_id, :source_id, :first_name, :last_name, :company, :title, :email_address, :cc_email_address,
      :work_phone, :participant, :event_id, :event_code, :event_title, :event_start_date, :status, :internal_note,
      :original_response_date, :contact_id, :registration_type, :registration_type_code, :home_postal_code, :work_postal_code, :order_details, :biography

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
      puts "test1"
      begin
        response = Cvent::Client.instance.call(:search, message)
        puts "test2"

        if response.body && response.body[:search_response] && response.body[:search_response][:search_result] && response.body[:search_response][:search_result][:id]
          ids = response.body[:search_response][:search_result][:id]

          ids = [ids] if ids.is_a? String

          #return ids
          return Cvent::Registration.fetch_from_ids(ids)

        else
          return response.body
        end
      rescue => e
        return []
      end
    end

    def self.fetch_from_ids(registration_ids=[])

      ##fetch registrations in batches of 200
      batch_size=200
      all_registrants_result = []
      a_id_list = registration_ids #an array of attendee ids

      j = (a_id_list.length / batch_size.to_f).ceil #need to make attendee detail call in groups of 200 ids
      a_end = a_id_list.length

      puts "a_id_list: #{a_id_list.length}"
      puts "J IS: #{j}"

      for i in 0..j-1

        puts "HERE"
        if (i < j-1) then
          max = batch_size
        else
          max = a_end - (i*batch_size)
        end
        start_val = (i * batch_size)
        end_val = start_val + max - 1

        puts "start val: #{start_val} end val: #{end_val}"
        a_id_sublist = a_id_list[start_val..end_val] #production
        # a_id_sublist = a_id_list[0..5] #testing only

        #subset result
        registration_ids = a_id_sublist

        message = {
          "ObjectType" => self::OBJECT_TYPE,
          "ins0:Ids" => { "ins0:Id" => registration_ids }
        }

        next if registration_ids.empty?

        # begin
          response = Cvent::Client.instance.call(:retrieve, message)

          if response.body && response.body[:retrieve_response] && response.body[:retrieve_response][:retrieve_result] && response.body[:retrieve_response][:retrieve_result][:cv_object]
            registrations = response.body[:retrieve_response][:retrieve_result][:cv_object]

            registrations = [registrations] if registrations.is_a? Hash

            puts registrations.length

            registrations = registrations.collect { |s| self.transform_to_registration_object(s) }

            contact_ids = []
            registrations.each do |registration|
              contact_ids << registration.contact_id
            end

            contacts = Cvent::Registration.fetch_contact_from_ids(contact_ids)

            #retrieve RegistrationType from Registration API endpoint
            #and contact details from Contact API endpoint
            registrations.each_with_index do |registration,i|
              registration.home_postal_code = contacts[i][:@home_postal_code]
              registration.work_postal_code = contacts[i][:@work_postal_code]
#               registration.order_details = contacts[i][:@order_detail]
            end

            #append the current batch to the final result list
            all_registrants_result.concat(registrations)
          end
        # rescue
        #   return []
        # end

      end #for i in 0..j-1

      return all_registrants_result
    end


    # def self.find_registration_object(invitee_id,event_id)
    #   message = {
    #     "ObjectType" => "Registration",
    #     "ins0:CvSearchObject" => {
    #       :attributes! => { "SearchType" => "AndSearch" },
    #       "ins0:Filter" => {
    #         "ins0:Field" => "InviteeId",
    #         "ins0:Operator" => "Equals",
    #         "ins0:Value" => invitee_id
    #       },
    #       "ins1:Filter" => {
    #           "ins1:Field" => "EventId",
    #           "ins1:Operator" => "Equals",
    #           "ins1:Value" => event_id
    #         }

    #     }
    #   }
    #   begin
    #     response = Cvent::Client.instance.call(:search, message)

    #     if response.body && response.body[:search_response] && response.body[:search_response][:search_result] && response.body[:search_response][:search_result][:id]
    #       ids = response.body[:search_response][:search_result][:id]
    #       ids = [ids] if ids.is_a? String

    #       return Cvent::Invitee.fetch_registration_from_ids(ids)

    #     else
    #       return []
    #     end
    #   rescue => e
    #     return []
    #   end

    # end


    # def self.fetch_registration_from_ids(ids)

    #    message = {
    #       "ObjectType" => "Registration",
    #       "ins0:Ids" => { "ins0:Id" => ids }
    #     }
    #     begin
    #       response = Cvent::Client.instance.call(:retrieve, message)

    #       if response.body && response.body[:retrieve_response] && response.body[:retrieve_response][:retrieve_result] && response.body[:retrieve_response][:retrieve_result][:cv_object]
    #         registrations = response.body[:retrieve_response][:retrieve_result][:cv_object]

    #         registrations = [registrations] if registrations.is_a? Hash

    #         return registrations[0]


    #       else
    #         return []
    #       end
    #     rescue => e
    #       return []
    #     end

    # end


   # def self.find_contact_object(contact_id)
   #    message = {
   #      "ObjectType" => "Contact",
   #      "ins0:CvSearchObject" => {
   #        :attributes! => { "SearchType" => "AndSearch" },
   #        "ins0:Filter" => {
   #          "ins0:Field" => "Id",
   #          "ins0:Operator" => "Equals",
   #          "ins0:Value" => contact_id
   #        }
   #      }
   #    }
   #    begin
   #      response = Cvent::Client.instance.call(:search, message)

   #      if response.body && response.body[:search_response] && response.body[:search_response][:search_result] && response.body[:search_response][:search_result][:id]
   #        ids = response.body[:search_response][:search_result][:id]
   #        ids = [ids] if ids.is_a? String

   #        return Cvent::Invitee.fetch_contact_from_ids(ids)

   #      else
   #        #return []
   #      end
   #    rescue => e
   #      #return []
   #    end

   #  end


    def self.fetch_contact_from_ids(ids)

       message = {
          "ObjectType" => "Contact",
          "ins0:Ids" => { "ins0:Id" => ids }
        }
        # begin
          response = Cvent::Client.instance.call(:retrieve, message)

          if response.body && response.body[:retrieve_response] && response.body[:retrieve_response][:retrieve_result] && response.body[:retrieve_response][:retrieve_result][:cv_object]
            contacts = response.body[:retrieve_response][:retrieve_result][:cv_object]

            contacts = [contacts] if contacts.is_a? Hash

            return contacts


          else
            return []
          end
        # rescue => e
        #   return []
        # end

    end


    private

    def self.transform_to_registration_object(registration)

      #puts "start transform #{registration}"

      # s = {} #Cvent::Registration.new
      # s["id"] = "111"

      s = Cvent::Registration.new

      s.id = registration[:@id]
      s.contact_id = registration[:@contact_id]
      s.source_id = registration[:@source_id]
      s.first_name = registration[:@first_name]
      s.last_name = registration[:@last_name]
      s.company = registration[:@company]
      s.title = registration[:@title]
      s.email_address = registration[:@email_address]
      s.cc_email_address = registration[:@cc_email_address]
      s.work_phone = registration[:@work_phone]
      s.participant = registration[:@participant]
      s.event_id = registration[:@event_id]
      s.event_code = registration[:@event_code]
      s.event_title = registration[:@event_title]
      s.event_start_date = registration[:@event_start_date]
      s.status = registration[:@status]
      s.internal_note = registration[:@internal_note]
      s.original_response_date = registration[:@original_response_date]
      s.registration_type = registration[:@registration_type]
      s.registration_type_code = registration[:@registration_type_code]
	    s.order_details = []
	    s.biography = ''

      if registration[:custom_field_detail]
        registration[:custom_field_detail].each do |field|
          s.custom_fields << Cvent::CustomField.create_from_hash(field)
        end
      end

      if registration[:order_detail]
      	registration[:order_detail].each do |order|
      	  detail = Cvent::OrderDetail.create_from_hash(order)
      	  s.order_details << detail if detail.product_type==="Session"
      	end
      end

      if registration[:event_survey_detail]
    	  result = Cvent::SurveyDetail.create_from_hash(registration[:event_survey_detail])
    	  s.biography = result
      end

      return s
    end

  end
end
