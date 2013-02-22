class CreateLoadableDbs < ActiveRecord::Migration
  def change
    create_table :loadable_dbs do |t|
      t.string :db
      t.string :common_name
      t.boolean :genome_sequenced
      t.boolean :default

      t.timestamps
    end
  end
end
