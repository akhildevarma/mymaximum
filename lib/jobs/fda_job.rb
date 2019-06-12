class FdaJob < Struct.new(:topic_search_id)
  def perform
    topic_search = TopicSearch.find(topic_search_id)
    begin
      if topic_search.drug_name.present?
        query = Fda::DrugNameSearch.new(topic_search.drug_name)
        unless query.drug_info.empty?
          topic_search.fda_result = { data: query.drug_info, more_results_url: query.more_results_url }.to_json
        end
      end
    ensure
      topic_search.fda_query_complete = true
      topic_search.save!
    end
  end
end
