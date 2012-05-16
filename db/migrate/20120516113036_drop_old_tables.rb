class DropOldTables < ActiveRecord::Migration
  def up
    drop_table :result_rows
    drop_table :result_rows_sequences
    drop_table :results
    drop_table :sequences
  end

  def down
    create_table "result_rows", :force => true do |t|
    t.integer  "result_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    end

    add_index "result_rows", ["result_id"], :name => "index_result_rows_on_result_id"

    create_table "result_rows_sequences", :force => true do |t|
      t.integer  "result_row_id", :null => false
      t.integer  "sequence_id",   :null => false
      t.datetime "created_at",    :null => false
      t.datetime "updated_at",    :null => false
    end
    
    add_index "result_rows_sequences", ["result_row_id", "sequence_id"], :name => "index_result_rows_sequences_on_result_row_id_and_sequence_id", :unique => true
    add_index "result_rows_sequences", ["result_row_id"], :name => "index_result_rows_sequences_on_result_row_id"
    add_index "result_rows_sequences", ["sequence_id"], :name => "index_result_rows_sequences_on_sequence_id"

    create_table "results", :force => true do |t|
      t.date     "date"
      t.integer  "profile_id"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
    
    add_index "results", ["profile_id"], :name => "index_results_on_profile_id"

    create_table "sequences", :force => true do |t|
      t.string   "seq"
      t.integer  "biosql_id"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
    
  end
end
