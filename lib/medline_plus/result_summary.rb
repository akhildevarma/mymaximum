module MedlinePlus
  class ResultSummary
    include HTTParty

    base_uri 'http://vsearch.nlm.nih.gov/'

    SANITIZE_CONFIG = { elements: ['ul', 'li', 'a', 'p', 'strong'],
                        attributes: { 'a' => ['href', 'title'] } }

    attr_reader :title, :url, :why_prescribed

    def initialize(node)
      header = node.css('.document-header').first
      body = node.css('.document-body').first
      @title = header.text.strip
      @url = self.class.base_uri + header.css('a').first['href']
      @summary = sanitize_and_stringify body
    end

    private

    def sanitize_and_stringify(nokogiri_node)
      Sanitize.clean(nokogiri_node.to_html, SANITIZE_CONFIG).strip.gsub(/\s+/, ' ') if nokogiri_node
    end
  end
end
