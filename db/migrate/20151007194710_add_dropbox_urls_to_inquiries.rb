class AddDropboxUrlsToInquiries < ActiveRecord::Migration
  def change
    add_column :inquiries, :dropbox_urls, :text
  end
end
