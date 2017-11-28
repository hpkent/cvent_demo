module Cvent
  class CustomField
    OBJECT_TYPE = "CustomField"

    attr_accessor :name, :value, :cvent_field_id, :type

    def self.create_from_hash(hash={})
      field = Cvent::CustomField.new

      field.name = hash[:@field_name]
      field.type = hash[:@field_type]
      field.cvent_field_id = hash[:@field_id]
      field.value = hash[:@field_value]

      return field
    end
  end
end
