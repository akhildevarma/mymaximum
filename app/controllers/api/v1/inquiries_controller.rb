class API::V1::InquiriesController < ApplicationController
  before_filter :require_provider
  before_filter :set_scoped_resource

  def show
    @inquiry = @resource.closed.find(params[:id])
    unless @inquiry.received?
      @inquiry.mark_response_received!
      SurveyProcessor.new(user_id: @inquiry.submitter_id).start_initial_survey # if it hasn't already been sent
    end
    @inquiry = @inquiry.decorate
    render
  rescue
    nr_options = {
      uri: request.fullpath.split('?').first,
      custom_params: {
        request_params: params,
        resource_errors_json: resource_errors_json
      }
    }
    NewRelicRemote.report(@inquiry, nr_options)
    render_after_error
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:question, :turnaround_time).merge(submitter: current_user)
  end

  def set_scoped_resource
    @resource = Inquiry.where(submitter_id: current_user.id)
  end

  def render_after_error
    errors = [] << resource_errors_json || '404 Record not found'
    render json: { errors: errors }, status: 404
  end

  def resource_errors_json
    @inquiry.try(:errors).try(:to_json)
  end
end
