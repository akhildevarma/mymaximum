class TopicSearchSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :medline_plus_result_url, :guideline_gov_result_url, :daily_med_result_url, :fda_result_url, :errors

  def medline_plus_result_url
    topic_search_medline_plus_result_url(object, format: :json)
  end

  def guideline_gov_result_url
    topic_search_guideline_gov_result_url(object, format: :json)
  end

  def daily_med_result_url
    topic_search_daily_med_result_url(object, format: :json)
  end

  def fda_result_url
    topic_search_fda_result_url(object, format: :json)
  end
end
