class HomeButtonGroup < ActiveRecord::Base

	belongs_to :event
	belongs_to :event_file	
end

class Event < ActiveRecord::Base
end

class EventMap < ActiveRecord::Base

	belongs_to :event
	belongs_to :map_type
	belongs_to :event_file, :foreign_key => 'map_event_file_id'
	has_many :location_mappings, :foreign_key => 'map_id', :dependent => :nullify

end

class EventFile < ActiveRecord::Base
	belongs_to :event_file_type
end

class EventFileType < ActiveRecord::Base
	has_many :event_files
end

class MapType < ActiveRecord::Base

	has_many :event_maps
end

class Session < ActiveRecord::Base

	belongs_to :location_mapping
	belongs_to :event
	
	has_many :sessions_speakers, :dependent => :destroy
	has_many :speakers, :through => :sessions_speakers
	has_many :tags_sessions, :dependent => :destroy
	has_many :tags, :through => :tags_sessions

	has_many :sessions_attendees
	has_many :attendees, :through => :sessions_attendees

end


class Tag < ActiveRecord::Base

  has_many :tags_session, :dependent => :destroy
  has_many :tags_exhibitor, :dependent => :destroy
  has_many :sessions, :through => :tags_session
  has_many :exhibitors, :through => :tags_exhibitor
 
  belongs_to :tag_type
end

class LocationMapping < ActiveRecord::Base
	belongs_to :location_mapping_type, :foreign_key => "mapping_type"
	belongs_to :event_map, :foreign_key => "map_id"
	has_many :sessions, :dependent => :nullify
	has_many :exhibitors, :dependent => :nullify
end

class LocationMappingType < ActiveRecord::Base

	has_many :location_mappings

end

class SessionsSpeaker < ActiveRecord::Base

	belongs_to :speaker_type
	belongs_to :session
	belongs_to :speaker
end

class Speaker < ActiveRecord::Base

	belongs_to :speaker_type
	belongs_to :event_file_photo, :foreign_key => 'photo_event_file_id', :class_name => "EventFile"
	belongs_to :event_file_cv, :foreign_key => 'cv_event_file_id', :class_name => "EventFile"
	belongs_to :event_file_fd, :foreign_key => 'fd_event_file_id', :class_name => "EventFile"

	has_many :sessions_speakers, :dependent => :destroy
	has_many :sessions, :through => :sessions_speakers

end

class SpeakerType < ActiveRecord::Base

	has_many :speakers
end

class TagType < ActiveRecord::Base
  
  has_many :tags
  
end

class TagsExhibitor < ActiveRecord::Base

  belongs_to :exhibitor
  belongs_to :tag
end


class TagsSession < ActiveRecord::Base

  belongs_to :session
  belongs_to :tag

end

class Attendee < ActiveRecord::Base

	has_many :sessions, :through => :sessions_attendees
	has_many :sessions_attendees, :dependent => :destroy
	
end

class SessionsAttendee < ActiveRecord::Base

	belongs_to :session
	belongs_to :attendee
	
end


