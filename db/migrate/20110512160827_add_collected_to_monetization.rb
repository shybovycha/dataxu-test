class AddCollectedToMonetization < ActiveRecord::Migration
  def self.up
    add_column :monetizations, :collected, :integer, :default => false
    remove_column :currencies, :collected
  end

  def self.down
    remove_column :monetizations, :collected
  end
end
