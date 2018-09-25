class AddAuthorToBlogEntries < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_blog_entries, :author, :string
  end
end
