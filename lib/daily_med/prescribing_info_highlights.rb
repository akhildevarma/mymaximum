

module DailyMed
  class PrescribingInfoHighlights
    HEADERS_TO_H6_TRANSFORMER = ->(env) do
      node = env[:node]
      node_name = env[:node_name]
      return if env[:is_whitelisted] || !node.element? || !%w{h1 h2 h3 h4 h5}.include?(node_name)
      node.name = 'h6'
    end

    LOCAL_TO_ABSOLUTE_HREFS_TRANSFORMER = ->(page_url) do
      # there are lots of links to named anchors in these documents,
      # but they're not usually fully qualified, so let's qualify them
      return ->(env) do
        return unless env[:node_name] == 'a' && env[:node].keys.include?('href')
        node = env[:node]
        absolute_href = URI.join(page_url, node['href'])
        node['href'] = absolute_href
      end
    end

    def initialize(spl)
      @spl = spl
      response = HTTParty.get(spl[:url])
      @html = parse_and_clean_response(response)
    end

    def to_json
      self.to_hash.to_json
    end

    def to_hash
      @spl.merge(html: @html)
    end

    private

    def sanitize_config
      {
        elements: %w(p table tr td ul li br a h6),
        attributes: { 'a' => ['href', 'title'], 'td' => ['colspan', 'rowspan'] },
        add_attributes: { 'table' => { 'class' => 'table table-bordered' } },
        transformers: [HEADERS_TO_H6_TRANSFORMER, LOCAL_TO_ABSOLUTE_HREFS_TRANSFORMER.call(@spl[:url])]
      }
    end

    def parse_and_clean_response(response)
      doc = Nokogiri::HTML.parse(response.body)
      nlm_highlights_anchor_node = doc.search("[text()*='HIGHLIGHT']")[0]
      # ^ this is a named anchor with no href, reading: "HIGHLIGHTS OF PRESCRIBING INFO"
      return unless nlm_highlights_anchor_node # not all SPLs have prescribing info highlights
      nlm_highlights_node = nlm_highlights_anchor_node.parent
      nlm_highlights_anchor_node.name = 'h6' # no need for it to be an anchor anymore!
      Sanitize.clean(nlm_highlights_node.to_html, sanitize_config).gsub(/\s+/, ' ')
    end
  end
end
