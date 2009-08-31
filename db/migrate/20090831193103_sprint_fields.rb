class SprintFields < ActiveRecord::Migration
  def self.up
    add_column :users, :sprint_api_key, :string
    add_column :users, :sprint_mdn, :string
  end

  def self.down
    remove_column :users, :sprint_api_key
    remove_column :users, :sprint_mdn
  end
end
