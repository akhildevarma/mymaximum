class API::Legacy::TopicSearches::DailyMedResultsController < ApplicationController
  before_filter :require_user
  respond_to :json

  def show
    @topic_search = TopicSearch.submitted_by(current_user).find(params[:topic_search_id])

    if @topic_search.daily_med_query_complete?
      respond_with @topic_search, serializer: TopicSearchSerializer
    else
      head :service_unavailable
    end


  end

end
