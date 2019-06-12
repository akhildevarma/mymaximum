class TableParser
  def self.html_to_json(html)
    html_doc = Nokogiri::HTML(html) do |config|
      config.strict.nonet
    end

    table_html = html_doc.css('table')[0]
    return nil unless table_html.present?

    rows = []
    table_html.css('tr').each do |tr|
      row = process_row_html(tr)
      rows << row
    end

    { body: rows } # https://github.com/rails/rails/issues/11169 
  end

  def self.process_row_html(row_html)
    row = [] 
    row_html.css('td').each do |child|
      if child.name == 'td'
        row << process_cell_html(child)
      end
    end
    row
  end

  def self.process_cell_html(cell_html)
    cell = {}
    cell[:rowspan] = (cell_html.get_attribute('rowspan') || 1).to_i
    cell[:colspan] = (cell_html.get_attribute('colspan') || 1).to_i
    cell[:value] = ''
    cell_html.children.each do |child|
      cell[:value] += CGI.escapeHTML(child.text)
    end
    cell[:value] = cell[:value].strip

    cell
  end
end
