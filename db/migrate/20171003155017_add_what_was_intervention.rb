class AddWhatWasIntervention < ActiveRecord::Migration
  def change
    add_column :survey_responses, :what_was_intervention, :text
  end
end
