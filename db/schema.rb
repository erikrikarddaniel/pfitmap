# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120328132746) do

  create_table "hmm_profiles", :force => true do |t|
    t.string   "name"
    t.string   "version"
    t.string   "hierarchy"
    t.integer  "parent_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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

  create_table "sequence_dbs", :force => true do |t|
    t.string   "source"
    t.string   "name"
    t.string   "version"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sequences", :force => true do |t|
    t.string   "seq"
    t.integer  "biosql_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
