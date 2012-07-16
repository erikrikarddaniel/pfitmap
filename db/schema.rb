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

ActiveRecord::Schema.define(:version => 20120716084808) do

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
    t.index ["db_sequence_id"], :name => "index_hmm_result_rows_on_db_sequence_id"
  end

  create_table "hmm_results", :force => true do |t|
    t.datetime "executed"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "hmm_profile_id"
    t.integer  "sequence_source_id", :null => false
    t.index ["hmm_profile_id"], :name => "index_hmm_results_on_hmm_profile_id"
    t.index ["sequence_source_id"], :name => "index_hmm_results_on_sequence_source_id"
  end

  create_view "db_sequence_best_profiles", "SELECT hmmrr.db_sequence_id, hmmr.hmm_profile_id, hmmr.sequence_source_id, hmmrr.id AS hmm_result_row_id, hmmrr.fullseq_score FROM (hmm_results hmmr JOIN hmm_result_rows hmmrr ON ((hmmr.id = hmmrr.hmm_result_id))) WHERE (hmmrr.fullseq_score = (SELECT max(hmmrrinner.fullseq_score) AS max FROM (hmm_result_rows hmmrrinner JOIN hmm_results hmmrinner ON ((hmmrrinner.hmm_result_id = hmmrinner.id))) WHERE ((hmmrrinner.db_sequence_id = hmmrr.db_sequence_id) AND (hmmrinner.sequence_source_id = hmmr.sequence_source_id))))", :force => true
  create_table "db_sequences", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "enzyme_profiles", :force => true do |t|
    t.integer  "hmm_profile_id"
    t.integer  "enzyme_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.index ["enzyme_id"], :name => "index_enzyme_profiles_on_enzyme_id"
    t.index ["hmm_profile_id"], :name => "index_enzyme_profiles_on_hmm_profile_id"
  end

  create_table "enzymes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "hmm_db_hits", :force => true do |t|
    t.integer  "gi"
    t.string   "db"
    t.string   "acc"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "db_sequence_id"
    t.text     "desc"
    t.index ["db", "acc"], :name => "index_hmm_db_hits_on_db_and_acc"
    t.index ["db_sequence_id"], :name => "index_hmm_db_hits_on_db_sequence_id"
    t.index ["gi"], :name => "index_hmm_db_hits_on_gi"
  end

  create_table "hmm_profiles", :force => true do |t|
    t.string   "name"
    t.string   "version"
    t.string   "hierarchy"
    t.integer  "parent_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "protein_name"
  end

  create_table "hmm_score_criteria", :force => true do |t|
    t.float    "min_fullseq_score"
    t.integer  "hmm_profile_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.index ["hmm_profile_id"], :name => "index_hmm_score_criterions_on_hmm_profile_id"
  end

  create_table "sequence_sources", :force => true do |t|
    t.string   "source"
    t.string   "name"
    t.string   "version"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pfitmap_releases", :force => true do |t|
    t.string   "release"
    t.date     "release_date"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.boolean  "current"
    t.integer  "sequence_source_id"
    t.index ["sequence_source_id"], :name => "index_pfitmap_releases_on_sequence_source_id"
    t.foreign_key ["sequence_source_id"], "sequence_sources", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "pfitmap_releases_sequence_source_id_fkey"
  end

  create_table "pfitmap_sequences", :force => true do |t|
    t.integer  "db_sequence_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "pfitmap_release_id"
    t.integer  "hmm_profile_id"
    t.index ["db_sequence_id"], :name => "index_pfitmap_sequences_on_db_sequence_id"
    t.index ["hmm_profile_id"], :name => "index_pfitmap_sequences_on_hmm_profile_id"
    t.index ["pfitmap_release_id"], :name => "index_pfitmap_sequences_on_pfitmap_release_id"
    t.foreign_key ["hmm_profile_id"], "hmm_profiles", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "pfitmap_sequences_hmm_profile_id_fkey"
  end

  create_table "proteins", :force => true do |t|
    t.string   "name"
    t.string   "rank"
    t.integer  "hmm_profile_id"
    t.integer  "enzyme_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.index ["enzyme_id"], :name => "index_proteins_on_enzyme_id"
    t.index ["hmm_profile_id"], :name => "index_proteins_on_hmm_profile_id"
    t.foreign_key ["hmm_profile_id"], "hmm_profiles", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "proteins_hmm_profile_id_fkey"
    t.foreign_key ["enzyme_id"], "enzymes", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "proteins_enzyme_id_fkey"
  end

  create_table "taxons", :force => true do |t|
    t.string   "name"
    t.string   "rank"
    t.boolean  "wgs"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "protein_counts", :force => true do |t|
    t.integer  "no_genomes"
    t.integer  "no_proteins"
    t.integer  "no_genomes_with_proteins"
    t.integer  "protein_id"
    t.integer  "pfitmap_release_id"
    t.integer  "taxon_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.index ["pfitmap_release_id"], :name => "index_protein_counts_on_pfitmap_release_id"
    t.index ["protein_id"], :name => "index_protein_counts_on_protein_id"
    t.index ["taxon_id"], :name => "index_protein_counts_on_taxon_id"
    t.foreign_key ["protein_id"], "proteins", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "protein_counts_protein_id_fkey"
    t.foreign_key ["pfitmap_release_id"], "pfitmap_releases", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "protein_counts_pfitmap_release_id_fkey"
    t.foreign_key ["taxon_id"], "taxons", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "protein_counts_taxon_id_fkey"
  end

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "role"
  end

end
