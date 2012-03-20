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

ActiveRecord::Schema.define(:version => 20120320203256) do

  create_table "profiles", :force => true do |t|
    t.string   "name"
    t.integer  "parent_profile_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "result_seq_relations", :force => true do |t|
    t.integer  "result_id"
    t.integer  "sequence_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "result_seq_relations", ["result_id", "sequence_id"], :name => "index_result_seq_relations_on_result_id_and_sequence_id", :unique => true
  add_index "result_seq_relations", ["result_id"], :name => "index_result_seq_relations_on_result_id"
  add_index "result_seq_relations", ["sequence_id"], :name => "index_result_seq_relations_on_sequence_id"

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
