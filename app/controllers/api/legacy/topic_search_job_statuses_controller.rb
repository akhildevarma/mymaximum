class API::Legacy::TopicSearchJobStatusesController < ApplicationController
  before_filter :require_user

  respond_to :json
  def show
    topic_search = TopicSearch.submitted_by(current_user).find(params[:topic_search_id])
    render json: topic_search.job_statuses
  end
end
