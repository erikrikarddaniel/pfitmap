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

ActiveRecord::Schema.define(:version => 20120516124425) do

  create_table "db_sequences", :force => true do |t|
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "aa_sequence"
  end

  create_table "hmm_db_hits", :force => true do |t|
    t.integer  "gi"
    t.string   "db"
    t.string   "acc"
    t.string   "desc"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "db_sequence_id"
  end

  add_index "hmm_db_hits", ["db", "acc"], :name => "index_hmm_db_hits_on_db_and_acc", :unique => true
  add_index "hmm_db_hits", ["db_sequence_id"], :name => "index_hmm_db_hits_on_db_sequence_id"
  add_index "hmm_db_hits", ["gi"], :name => "index_hmm_db_hits_on_gi"

  create_table "hmm_profiles", :force => true do |t|
    t.string   "name"
    t.string   "version"
    t.string   "hierarchy"
    t.integer  "parent_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "hmm_result_rows", :force => true do |t|
    t.string   "target_name"
    t.string   "target_acc"
    t.string   "query_name"
    t.string   "query_acc"
    t.float    "fullseq_evalue"
    t.float    "fullseq_score"
    t.float    "fullseq_bias"
    t.float    "bestdom_evalue"
    t.float    "bestdom_score"
    t.float    "bestdom_bias"
    t.float    "domnumest_exp"
    t.integer  "domnumest_reg"
    t.integer  "domnumest_clu"
    t.integer  "domnumest_ov"
    t.integer  "domnumest_env"
    t.integer  "domnumest_rep"
    t.integer  "domnumest_inc"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "hmm_result_id"
    t.integer  "domnumest_dom"
    t.integer  "db_sequence_id"
  end

  add_index "hmm_result_rows", ["db_sequence_id"], :name => "index_hmm_result_rows_on_db_sequence_id"

  create_table "hmm_results", :force => true do |t|
    t.datetime "executed"
    t.integer  "sequence_db_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "hmm_profile_id"
  end

  add_index "hmm_results", ["hmm_profile_id"], :name => "index_hmm_results_on_hmm_profile_id"
  add_index "hmm_results", ["sequence_db_id"], :name => "index_hmm_results_on_sequence_db_id"

  create_table "sequence_dbs", :force => true do |t|
    t.string   "source"
    t.string   "name"
    t.string   "version"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
