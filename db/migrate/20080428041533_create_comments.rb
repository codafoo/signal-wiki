class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :page_id, :site_id
      t.string  :subject, :author
      t.text    :body
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
