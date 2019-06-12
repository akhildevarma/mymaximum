class RemoveContactPreferenceFromProvider < ActiveRecord::Migration
  def change
    remove_column :providers, :contact_preference, :string
  end
end
