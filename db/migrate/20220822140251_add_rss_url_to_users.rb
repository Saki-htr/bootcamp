class AddRssUrlToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :rss_url, :string
  end
end
