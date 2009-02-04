class ResponseNames < ActiveRecord::Migration
  def self.up
    add_column :responses, :name, :string
  end

  def self.down
    remove_column :responses, :name
  end
end
