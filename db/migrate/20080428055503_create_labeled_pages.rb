class CreateLabeledPages < ActiveRecord::Migration
  def self.up
    create_table :labeled_pages do |t|
      t.integer :label_id, :page_id
      t.timestamps
    end
  end

  def self.down
    drop_table :labeled_pages
  end
end
