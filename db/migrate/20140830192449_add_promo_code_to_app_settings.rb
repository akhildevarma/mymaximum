class AddPromoCodeToAppSettings < ActiveRecord::Migration
  def change
    add_column :application_settings, :allow_promo_code, :boolean, default: false
    add_column :users, :promo_code, :string, null: true
  end
end
