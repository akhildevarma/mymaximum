class CreateFlaggedComments < ActiveRecord::Migration
  def change
    create_table :flagged_comments do |t|
    	t.belongs_to :user, null: false
      t.belongs_to :comment, null: false
      t.timestamps
    end
    add_index :flagged_comments, [:user_id, :comment_id], unique: true
  end
end
