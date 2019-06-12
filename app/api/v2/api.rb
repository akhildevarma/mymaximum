require 'grape'
require 'grape-active_model_serializers'
# require "garner/mixins/rack"
  class API < Grape::API

	  format :json
	  rescue_from Grape::Exceptions::ValidationErrors do |e|
		  rack_response({
		    status: 400,
		    error_msg: e.message,
		  }.to_json, 400)
		end
    rescue_from :all do |e|
		  rack_response({
		    status: 500,
		    error_msg: e.message
		  }.to_json, 500)
		end
	  rescue_from :all, :backtrace => true
	   ActiveModelSerializers.config.jsonapi_include_toplevel_object = true
	   ActiveModelSerializers.config.serializer_lookup_enabled = false
	  # formatter :json, Grape::Formatter::ActiveModelSerializers
	  # error_formatter :json, Grape::ErrorFormatter::Json
	  content_type :json, 'application/vnd.api+json'
	  version 'v2', using: :path
	  helpers ApiHelpers::ApiHelper

    mount V2::Base

    add_swagger_documentation(
      base_path: "/api",
      hide_documentation_path: true,
      api_version: "v2"
  	)


end
