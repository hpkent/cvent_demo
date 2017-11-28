module Cvent
  class Link
    OBJECT_TYPE = "Link"

    attr_accessor :target, :url

    def self.create_from_hash(hash={})
      link = Cvent::Link.new

      link.target = hash[:@target]
      link.url = hash[:@url]

      return link      
    end  
  end
end
