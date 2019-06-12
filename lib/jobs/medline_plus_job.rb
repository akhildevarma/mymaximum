class MedlinePlusJob < Struct.new(:topic_search_id)
  def perform
    topic_search = TopicSearch.find(topic_search_id)
    begin
      query = MedlinePlus::Search.new(topic_search.search_terms_with_drug_name)
      unless query.results.nil?
        topic_search.medline_plus_result = { data: query.results, more_results_url: query.more_results_url }.to_json
      end
    ensure
      topic_search.medline_plus_query_complete = true
      topic_search.save!
    end
  end
end
