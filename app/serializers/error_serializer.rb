class ErrorSerializer
  ERROR_TEXT = {
    blank: 'cant_be_blank',
    taken: 'taken',
    invalid: 'wrong_format',
    too_short: 'too_short',
    wrong_length: 'wrong_length',
    confirmation: lambda { |attribute| "must_match_#{attribute}" },
    accepted: 'must_be_accepted'
  }

  ERROR_TEXT_CUSTOMIZER = {
    password_confirmation: 'password'
  }

  def to_json(*args)
    attributes.to_json
  end

  ## Class Methods
  def self.excluded_attributes(*excluded_attributes)
    (excluded_attributes ? (@excluded_attributes ||= excluded_attributes.map(&:to_sym)) : @excluded_attributes)
  end

  private

  def initialize(model_instance)
    throw 'Object must be instance of ActiveModel::Model' unless model_instance.is_a? ActiveModel::Model
    @object = model_instance
  end

  def generate_json_messages_for(errors)
    throw 'Object must be instance of ActiveModel::Errors' unless errors.is_a? ActiveModel::Errors
    {}.tap do |error_messages|
      errors.details.each do |key, value|
        next if self.class.excluded_attributes.include? key
        value.each do |array_value|
          error = array_value[:error]
          error_message = if ERROR_TEXT[error].respond_to? :call
            throw 'Error message customization not provided' unless ERROR_TEXT_CUSTOMIZER[key].present?
            ERROR_TEXT[error].call(ERROR_TEXT_CUSTOMIZER[key])
                          else
            ERROR_TEXT[error]
          end
          (error_messages[key] ||=[]) << error_message
        end
      end
    end
  end

  def attributes
    {}.tap do |attributes|
      json_errors = @object.json_errors
      json_errors.each do |association, errors|
        attributes[association] = (errors.blank?) ? {} : generate_json_messages_for(errors)
      end
    end
  end
end
