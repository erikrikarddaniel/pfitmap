class CreateSequenceDbs < ActiveRecord::Migration
  def change
    create_table :sequence_dbs do |t|
      t.string :source
      t.string :name
      t.string :version

      t.timestamps
    end
  end
end
