class EmailFields < ActiveRecord::Migration
  def self.up
    remove_column :emails, :body
    remove_column :emails, :subject
    remove_column :emails, :from
    add_column :emails, :message, :text
    add_column :emails, :uid, :string
  end

  def self.down
    add_column :emails, :body, :text
    add_column :emails, :subject, :string
    add_column :emails, :from, :string
    remove_column :emails, :message
    remove_column :emails, :uid
  end
end
