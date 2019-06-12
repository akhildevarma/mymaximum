class MySummaryTableSerializer < ActiveModel::Serializer
  attributes :id, :body_html, :references
end
