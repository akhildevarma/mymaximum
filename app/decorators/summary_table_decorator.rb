class SummaryTableDecorator < Draper::Decorator
  delegate_all

  def body_html
    return '' unless model.body.present?

    body = model.body['body']
    return create_table(body) if body.is_a?(Array)

    # remove inline 'width' style from the table tag
    body.gsub(
      /<table style="width: (\d*)px; height: (\d*)px;">/,
      '<table class="table table-striped table-bordered" style="height: \2px;">'
    ).gsub(/<table/, '<table class="table table-striped table-bordered"')

  end

  def create_table(rows)
    '<table class="table table-striped table-bordered">' +
      rows.map { |row|
        '<tr>' + create_cells(row).join + '</tr>'
      }.join +
    '</table>'
  end

  def create_cells(row)
    row.map { |cell|
      "<td colspan=#{cell['colspan']} rowspan=#{cell['rowspan']}>#{cell['value']}</td>"
    }
  end
end
