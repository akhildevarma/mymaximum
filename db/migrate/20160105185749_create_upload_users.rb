class CreateUploadUsers < ActiveRecord::Migration
  def change
    create_table :upload_users do |t|
      t.string   :email,            limit: 255
      t.string   :first_name,       limit: 255
      t.string   :middle_name,      limit: 255
      t.string   :last_name,        limit: 255
      t.string   :name_suffix,      limit: 255
      t.string   :name_title,       limit: 255
      t.string   :company,          limit: 255
      t.string   :city,             limit: 255
      t.string   :state,            limit: 255
      t.string   :phone_number,     limit: 255
      t.string   :license_number,   limit: 255
      t.string   :licensing_state,  limit: 255
      t.string   :specialty,        limit: 255
      t.string   :promo_code,       limit: 255
      t.string   :status,           limit: 100
      t.integer  :team_id
      t.timestamps null: false
    end
  end
end
