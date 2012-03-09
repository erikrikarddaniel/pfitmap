class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name
      t.integer :parent_profile_id

      t.timestamps
    end
  end
end
