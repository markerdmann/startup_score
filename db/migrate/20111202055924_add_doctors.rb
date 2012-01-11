class AddDoctors < ActiveRecord::Migration
  def self.up
    create_table :startups do |t|
      t.string :name, :url
      t.integer :score
      t.timestamps
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
