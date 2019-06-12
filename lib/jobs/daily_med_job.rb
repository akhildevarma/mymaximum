class DailyMedJob < Struct.new(:topic_search_id)
  def perform
    topic_search = TopicSearch.find(topic_search_id)
    begin
      if topic_search.drug_name.present?
        query = DailyMed::DrugNameSearch.new(topic_search.drug_name)
        spls = query.spls
        unless spls.empty?
          first_spl_highlights = DailyMed::PrescribingInfoHighlights.new(spls[0])
          topic_search.daily_med_result = { data: [first_spl_highlights.to_hash] + spls[1..4], more_results_url: query.more_results_url }.to_json
        end
      end
    ensure
      topic_search.daily_med_query_complete = true
      topic_search.save!
    end
  end
end
