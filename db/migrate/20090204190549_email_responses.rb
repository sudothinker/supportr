class EmailResponses < ActiveRecord::Migration
  def self.up
    add_column :emails, :response_id, :integer
  end

  def self.down
    remove_column :emails, :response_id
  end
end
