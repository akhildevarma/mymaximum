class FdaDrugShortage < ActiveRecord::Base

  def self.reload(xml_param='UCM163172')
    drugs = Fda::DrugShortage.new(xml_param)
    drugs.load_drug_shortages
  end

  def self.search(query)
    if query.present?
      self.where("title ILIKE :search", search: "%#{query}%")
    else
      FdaDrugShortage.all
    end
  end
end
