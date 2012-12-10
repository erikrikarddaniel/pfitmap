class AddParentIdToEnzymes < ActiveRecord::Migration
  def change
    change_table :enzymes do |t|
      t.integer :parent_id
    end
  end
end
