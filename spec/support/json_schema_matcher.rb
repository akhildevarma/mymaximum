# spec/support/json_schema_matcher.rb

RSpec::Matchers.define :match_response_schema do |resource, version|
  match do |subject|
    schema_directory = "#{Dir.pwd}/doc/api/schema/schemata"
    schema_path = "#{schema_directory}/#{resource}"
    schema_path += "_#{version}" if version
    schema_path += ".json"
    JSON::Validator.validate!(schema_path, subject)
  end
end
