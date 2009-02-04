class EmailArchiveResponseId < ActiveRecord::Migration
  def self.up
    add_column :email_archives, :response_id, :integer
  end

  def self.down
    remove_column :email_archives, :response_id
  end
end
