class SummaryTable < ActiveRecord::Base
  belongs_to :inquiry, inverse_of: :summary_tables
  belongs_to :responder, class_name: 'User'

  validates :responder_id, presence: true
  validates :inquiry_id, presence: true

  def body_html=(html)
    self.body = { body: html }#TableParser.html_to_json(html) unless html.empty?
  end

  def data
    self.body['body']
  end
end
