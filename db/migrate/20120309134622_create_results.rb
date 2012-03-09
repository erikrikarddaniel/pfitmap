class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.date :date
      t.references :profile

      t.timestamps
    end
    add_index :results, :profile_id
  end
end
