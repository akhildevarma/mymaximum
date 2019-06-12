class MoveContactPreferenceFromProfilesToProviders < ActiveRecord::Migration
  def up
    add_column :providers, :contact_preference, :string
    execute 'UPDATE providers SET contact_preference = profiles.contact_preference FROM profiles WHERE providers.user_id = profiles.user_id'
    remove_column :profiles, :contact_preference
  end

  def down
    add_column :profiles, :contact_preference, :string
    execute 'UPDATE profiles SET contact_preference = providers.contact_preference FROM providers WHERE profiles.user_id = providers.user_id'
    remove_column :providers, :contact_preference
  end
end
