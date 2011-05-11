class CreateInitiaries < ActiveRecord::Migration
  def self.up
    create_table :initiaries do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :initiaries
  end
end
