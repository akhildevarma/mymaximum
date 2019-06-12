class AddDropboxUrlsToSummaryTables < ActiveRecord::Migration
  def change
    add_column :summary_tables, :dropbox_urls, :text
  end
end
