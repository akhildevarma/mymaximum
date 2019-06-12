FactoryGirl.define do
  factory :document do
    file { File.new("#{Rails.root}/static/table.template.docx") }
  end
end
