class CreateInitiarizations < ActiveRecord::Migration
  def self.up
    create_table :initiarizations do |t|
      t.integer :country_id
      t.integer :initiary_id

      t.timestamps
    end
  end

  def self.down
    drop_table :initiarizations
  end
end
