class ChangeDropboxUrlsToDropboxUrl < ActiveRecord::Migration
  def change
    rename_column :summary_tables, :dropbox_urls, :dropbox_url
  end
end
