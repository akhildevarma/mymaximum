class CreateSurveyResponses < ActiveRecord::Migration
  def change
    create_table :survey_responses do |t|
      t.references :user, index: true
      t.references :inquiry, index: true, unique: true
      t.boolean :appropriate
      t.integer :rating
      t.integer :recommendation_likelihood
      t.string :workflow_state

      t.timestamps
    end
  end
end
