class CreateHmmProfiles < ActiveRecord::Migration
  def change
    create_table :hmm_profiles do |t|
      t.string :name
      t.string :version
      t.string :hierarchy
      t.integer :parent_id

      t.timestamps
    end
  end
end
