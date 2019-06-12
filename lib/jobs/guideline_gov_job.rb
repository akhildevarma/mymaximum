class GuidelineGovJob < Struct.new(:topic_search_id)
  def perform
    topic_search = TopicSearch.find(topic_search_id)
    begin
      query = GuidelineGov::Search.new(topic_search.search_terms_with_drug_name)
      unless query.first_result.nil?
        topic_search.guideline_gov_result = { data: query.first_result, more_results_url: query.more_results_url }.to_json
      end
    ensure
      topic_search.guideline_gov_query_complete = true
      topic_search.save!
    end
  end
end
