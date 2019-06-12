class CreateFdaDrugShortages < ActiveRecord::Migration
  def change
    create_table :fda_drug_shortages do |t|
      t.string :title
      t.text :description
      t.string :link
      t.datetime :published_date

      t.timestamps
    end
  end
end
