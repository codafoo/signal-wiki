class AddAdminTextToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :admin_text, :text
  end

  def self.down
    remove_column :pages, :admin_text
  end
end
