class API::Legacy::TopicSearchesController < ApplicationController
  respond_to :json

  before_filter :require_user

  def create
    @topic_search = TopicSearch.new(topic_search_params)
    if @topic_search.valid? && @topic_search.save
      SurveyProcessor.new(user_id: current_user.id).start_initial_survey # if necessary
    end
    respond_with @topic_search, serializer: TopicSearchSerializer
  end

  def show
    @topic_search = TopicSearch.submitted_by(current_user).find(params[:topic_search_id])
    respond_with @topic_search, serializer: TopicSearchSerializer
  end

  def index
    @topic_searches = TopicSearch.submitted_by(current_user).reverse_chronological_order
    respond_with @topic_searches, each_serializer: TopicSearchSerializer
  end

  private

  def topic_search_params
    params.require(:topic_search)
      .permit(:search_terms, :drug_name)
      .merge(submitter: current_user)
  end
end
