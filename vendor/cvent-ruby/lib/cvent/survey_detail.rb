module Cvent
  class SurveyDetail
    OBJECT_TYPE = "SurveyDetail"

    attr_accessor :survey_type, :question_id, :question_code, :question_text, :answer_text, :biography

    def self.create_from_hash(array=[])
      field = Cvent::SurveyDetail.new
      biography = ''

      if array.is_a? Array
        array.each {|q|
          biography = q[:answer][:@answer_text] if q[:@question_id] == 'F053EAA3-67C3-4446-B41A-BC5801DC01F6' && q[:answer]}
      end
      biography
    end
  end
end
