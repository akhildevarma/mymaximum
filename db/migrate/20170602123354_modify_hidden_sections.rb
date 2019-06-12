class ModifyHiddenSections < ActiveRecord::Migration
  def change
    change_column :inquiries, :hidden_sections, 'jsonb USING CAST(hidden_sections AS jsonb)'
  end
end
