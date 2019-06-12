module MedlinePlus
  class HealthTopicsQuery
    include HTTParty

    base_uri 'wsearch.nlm.nih.gov:443/ws'
    default_params db: 'healthTopics', rettype: 'topic'

    attr_reader :more_results_url

    def initialize(search_term)
      @search_term = search_term
      @more_results_url = "http://vsearch.nlm.nih.gov/vivisimo/cgi-bin/query-meta?v:project=medlineplus&query=#{URI.encode_www_form_component(@search_term)}"
    end

    def topics(force:  false)
      force ? fetch_topics : @topics || fetch_topics
    end

    private

    def fetch_topics
      @topics = HealthTopic.list_from_query_result(self.class.get('/query', query: { term: @search_term }))
    end
  end
end
