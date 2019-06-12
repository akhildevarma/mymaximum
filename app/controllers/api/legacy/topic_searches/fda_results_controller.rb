class API::Legacy::TopicSearches::FdaResultsController < ApplicationController
  before_filter :require_user
  respond_to :json

  def show
    @topic_search = TopicSearch.submitted_by(current_user).find(params[:topic_search_id])
    head :service_unavailable unless @topic_search.fda_query_complete?
  end

end
