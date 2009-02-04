class EmailArchives < ActiveRecord::Migration
  class Email < ActiveRecord::Base
    is_archived
  end
  
  def self.up
    Email.create_archive_table
  end

  def self.down
    Email.drop_archive_table
  end
end
