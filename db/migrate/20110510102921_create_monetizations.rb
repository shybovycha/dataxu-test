class CreateMonetizations < ActiveRecord::Migration
  def self.up
    create_table :monetizations do |t|
      t.integer :country_id
      t.integer :currency_id

      t.timestamps
    end
  end

  def self.down
    drop_table :monetizations
  end
end
