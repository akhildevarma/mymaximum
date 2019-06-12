class CreateBlogImages < ActiveRecord::Migration
  def change
    create_table :blog_images do |t|
      t.integer :user_id
      t.string  :referenceable_type
      t.integer :referenceable_id
      t.attachment :image
      t.timestamps
    end
  end
end
