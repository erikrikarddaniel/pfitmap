class CreateSequences < ActiveRecord::Migration
  def change
    create_table :sequences do |t|
      t.string :seq
      t.integer :biosql_id

      t.timestamps
    end
  end
end
