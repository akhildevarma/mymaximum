module JsonErrorResource
  extend ActiveSupport::Concern
  include ActiveModel::Model

  def self.included(base)
  end

  class_methods do
    def json_error_associations(*error_associations)
      (error_associations ? (@error_associations ||= error_associations.map(&:to_sym)) : @error_associations)
    end
  end

  def json_errors
    {}.tap do |json_errors|
      json_errors[self.class.name.underscore.to_sym] = self.errors
      Array(self.class.json_error_associations).each do |error_association_symbol|
        error_association = self.send(error_association_symbol)
        errors = error_association.try(:errors) || {}
        throw 'json_error_associations must respond_to errors method' unless error_association.nil? || error_association.respond_to?(:errors)
        json_errors[error_association_symbol] = errors
      end
    end
  end
end
