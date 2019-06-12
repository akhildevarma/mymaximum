module MedlinePlus
  class Search
    include HTTParty

    base_uri 'http://vsearch.nlm.nih.gov/vivisimo/cgi-bin'
    default_params 'v:project': 'medlineplus'

    attr_reader :more_results_url

    def initialize(search_term)
      @search_term = search_term
    end

    def results(force: false)
      force ? fetch_results : @results || fetch_results
    end

    private

    def fetch_results
      @results = scrape_from(self.class.get('/query-meta', query: { query: @search_term }))
    end

    def scrape_from(response)
      @more_results_url = response.request.uri.to_s
      doc = Nokogiri::HTML(response)
      # Get first result from list
      results_nodes = doc.css("#search-results ol.results li")
      results = []
      results_nodes.each do |node|
          results << ResultSummary.new(node)
      end
      return results
    end

  end
end
