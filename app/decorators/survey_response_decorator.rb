class SurveyResponseDecorator < Draper::Decorator
  delegate_all

  decorates_association :responder 
end
