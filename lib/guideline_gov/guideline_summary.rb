module GuidelineGov
  class GuidelineSummary
    include HTTParty

    base_uri 'http://www.guideline.gov'

    SANITIZE_CONFIG = { elements: ['ul', 'li', 'a', 'p', 'strong'],
                        attributes: { 'a' => ['href', 'title'] } }

    attr_reader :title, :url, :bibliographic_sources, :condition, :objectives, :target_population,
                :interventions_considered, :outcomes_considered

    def initialize(url_fragment)
      doc = Nokogiri::HTML(self.class.get(url_fragment))

      content = doc.css('[role="tablist"]')
      combined_tabs = content.css('[role="tabpanel"]')
      fields, field_names, field_datas = parse_tabs_for_content(combined_tabs)
      # ["FDA Warning/Regulatory Alert",
      #  "Major Recommendations",
      #  "Clinical Algorithm(s)",
      #  "Disease/Condition(s)",
      #  "Guideline Category",
      #  "Clinical Specialty",
      #  "Intended Users",
      #  "Guideline Objective(s)",
      #  "Target Population",
      #  "Interventions and Practices Considered",
      #  "Major Outcomes Considered",
      #  "Methods Used to Collect/Select the Evidence",
      #  "Description of Methods Used to Collect/Select the Evidence",
      #  "Number of Source Documents",
      #  "Methods Used to Assess the Quality and Strength of the Evidence",
      #  "Rating Scheme for the Strength of the Evidence",
      #  "Methods Used to Analyze the Evidence",
      #  "Description of the Methods Used to Analyze the Evidence",
      #  "Methods Used to Formulate the Recommendations",
      #  "Description of Methods Used to Formulate the Recommendations",
      #  "Rating Scheme for the Strength of the Recommendations",
      #  "Cost Analysis",
      #  "Method of Guideline Validation",
      #  "Description of Method of Guideline Validation",
      #  "Type of Evidence Supporting the Recommendations",
      #  "Potential Benefits",
      #  "Potential Harms",
      #  "Contraindications",
      #  "Qualifying Statements",
      #  "Description of Implementation Strategy",
      #  "Implementation Tools",
      #  "IOM Care Need",
      #  "IOM Domain",
      #  "Bibliographic Source(s)",
      #  "Adaptation",
      #  "Date Released",
      #  "Guideline Developer(s)",
      #  "Source(s) of Funding",
      #  "Guideline Committee",
      #  "Composition of Group That Authored the Guideline",
      #  "Financial Disclosures/Conflicts of Interest",
      #  "Guideline Status",
      #  "Guideline Availability",
      #  "Availability of Companion Documents",
      #  "Patient Resources",
      #  "NGC Status",
      #  "Copyright Statement",
      #  "NGC Disclaimer"]

      @title = sanitize_and_stringify(doc.css('.content-header h1'))
      @url = self.class.base_uri + url_fragment
      @bibliographic_sources = sanitize_and_stringify(fields['Bibliographic Source(s)'])
      @condition = sanitize_and_stringify(fields['Disease/Condition(s)'])
      @objectives = sanitize_and_stringify(fields['Guideline Objective(s)'])
      @target_population = sanitize_and_stringify(fields['Target Population'])
      @interventions_considered = sanitize_and_stringify(fields['Interventions and Practices Considered'])
      @outcomes_considered = sanitize_and_stringify(fields['Major Outcomes Considered'])

    end

    private

    def sanitize_and_stringify(nokogiri_node)
      Sanitize.clean(nokogiri_node.to_html, SANITIZE_CONFIG).strip.gsub(/\s+/, ' ') if nokogiri_node
    end

    def parse_tabs_for_content(combined_tabs)
      combined_tabs = Nokogiri::HTML( combined_tabs.inner_html )
      elements = combined_tabs.css('body')[0].children.reject(&:text?)
      @sections = []
      elements.each do |e|
        @nodeset ||= Nokogiri::XML::NodeSet.new( Nokogiri::XML::Document.new )
        if e.name == 'h3'
          @sections << @nodeset unless @nodeset.empty?
          @nodeset = nil
        else
          @nodeset.push e
        end
      end
      field_names = combined_tabs.css('h3').map { |s| s.text.strip.gsub(/\s+/, ' ') }
      field_datas = @sections
      fields = Hash[field_names.zip field_datas]
      return [fields, field_names, field_datas]
    end

  end
end
