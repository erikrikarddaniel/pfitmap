class CreateResultRows < ActiveRecord::Migration
  def change
    create_table :result_rows do |t|
      t.references :result
      
      t.timestamps
    end
    add_index :result_rows, :result_id
  end
end
