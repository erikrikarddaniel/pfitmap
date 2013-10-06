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

ActiveRecord::Schema.define(:version => 20131004171623) do

  create_table "db_entries", :force => true do |t|
    t.integer  "gi"
    t.string   "db"
    t.string   "acc"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "db_sequence_id"
    t.text     "desc"
    t.index ["db", "acc"], :name => "index_db_entries_on_db_and_acc", :order => {"db" => :asc, "acc" => :asc}
    t.index ["db_sequence_id"], :name => "index_db_entries_on_db_sequence_id", :order => {"db_sequence_id" => :asc}
    t.index ["gi"], :name => "index_db_entries_on_gi", :order => {"gi" => :asc}
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
    t.index ["db_sequence_id"], :name => "index_hmm_result_rows_on_db_sequence_id", :order => {"db_sequence_id" => :asc}
  end

  create_table "hmm_results", :force => true do |t|
    t.datetime "executed"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "hmm_profile_id"
    t.integer  "sequence_source_id", :null => false
    t.index ["hmm_profile_id"], :name => "index_hmm_results_on_hmm_profile_id", :order => {"hmm_profile_id" => :asc}
    t.index ["sequence_source_id"], :name => "index_hmm_results_on_sequence_source_id", :order => {"sequence_source_id" => :asc}
  end

  create_view "db_sequence_best_profiles", "SELECT hmmrr.db_sequence_id, hmmr.hmm_profile_id, hmmr.sequence_source_id, hmmrr.id AS hmm_result_row_id, hmmrr.fullseq_score FROM (hmm_results hmmr JOIN hmm_result_rows hmmrr ON ((hmmr.id = hmmrr.hmm_result_id))) WHERE (hmmrr.fullseq_score = (SELECT max(hmmrrinner.fullseq_score) AS max FROM (hmm_result_rows hmmrrinner JOIN hmm_results hmmrinner ON ((hmmrrinner.hmm_result_id = hmmrinner.id))) WHERE ((hmmrrinner.db_sequence_id = hmmrr.db_sequence_id) AND (hmmrinner.sequence_source_id = hmmr.sequence_source_id))))", :force => true
  create_table "db_sequences", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "sequence"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.index ["priority", "run_at"], :name => "delayed_jobs_priority", :order => {"priority" => :asc, "run_at" => :asc}
  end

  create_table "enzyme_profiles", :force => true do |t|
    t.integer  "hmm_profile_id"
    t.integer  "enzyme_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.index ["enzyme_id"], :name => "index_enzyme_profiles_on_enzyme_id", :order => {"enzyme_id" => :asc}
    t.index ["hmm_profile_id"], :name => "index_enzyme_profiles_on_hmm_profile_id", :order => {"hmm_profile_id" => :asc}
  end

  create_table "enzymes", :force => true do |t|
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "abbreviation"
    t.integer  "parent_id"
    t.string   "name"
    t.index ["parent_id"], :name => "fk__enzymes_parent_id", :order => {"parent_id" => :asc}
    t.foreign_key ["parent_id"], "enzymes", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_enzymes_parent_id"
  end

  create_table "hmm_profiles", :force => true do |t|
    t.string   "name"
    t.string   "version"
    t.integer  "parent_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "protein_name"
    t.string   "hmm_logo_file_name"
    t.string   "hmm_logo_content_type"
    t.integer  "hmm_logo_file_size"
    t.datetime "hmm_logo_updated_at"
  end

  create_table "proteins", :force => true do |t|
    t.integer  "hmm_profile_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "protclass"
    t.string   "subclass"
    t.string   "group"
    t.string   "subgroup"
    t.string   "subsubgroup"
    t.string   "protfamily"
    t.index ["hmm_profile_id"], :name => "index_proteins_on_hmm_profile_id", :order => {"hmm_profile_id" => :asc}
    t.foreign_key ["hmm_profile_id"], "hmm_profiles", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "proteins_hmm_profile_id_fkey"
  end

  create_table "enzyme_proteins", :force => true do |t|
    t.integer  "enzyme_id"
    t.integer  "protein_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.index ["enzyme_id"], :name => "index_enzyme_proteins_on_enzyme_id", :order => {"enzyme_id" => :asc}
    t.index ["protein_id"], :name => "index_enzyme_proteins_on_protein_id", :order => {"protein_id" => :asc}
    t.foreign_key ["enzyme_id"], "enzymes", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "enzyme_proteins_enzyme_id_fkey"
    t.foreign_key ["protein_id"], "proteins", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "enzyme_proteins_protein_id_fkey"
  end

  create_table "hmm_alignments", :force => true do |t|
    t.integer  "hmm_result_row_id"
    t.float    "score"
    t.float    "bias"
    t.float    "cevalue"
    t.float    "ievalue"
    t.integer  "hmmfrom"
    t.integer  "hmmto"
    t.integer  "alifrom"
    t.integer  "alito"
    t.integer  "envfrom"
    t.integer  "envto"
    t.float    "acc"
    t.text     "hmm_line"
    t.text     "match_line"
    t.text     "target_line"
    t.text     "pp_line"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "domain_num"
    t.index ["hmm_result_row_id"], :name => "fk__hmm_alignments_hmm_result_row_id", :order => {"hmm_result_row_id" => :asc}
    t.foreign_key ["hmm_result_row_id"], "hmm_result_rows", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "hmm_alignments_hmm_result_row_id_fkey"
  end

  create_table "pfitmap_sequences", :force => true do |t|
    t.integer  "db_sequence_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "pfitmap_release_id"
    t.integer  "hmm_profile_id"
    t.index ["db_sequence_id"], :name => "index_pfitmap_sequences_on_db_sequence_id", :order => {"db_sequence_id" => :asc}
    t.index ["hmm_profile_id"], :name => "index_pfitmap_sequences_on_hmm_profile_id", :order => {"hmm_profile_id" => :asc}
    t.index ["pfitmap_release_id"], :name => "index_pfitmap_sequences_on_pfitmap_release_id", :order => {"pfitmap_release_id" => :asc}
    t.foreign_key ["hmm_profile_id"], "hmm_profiles", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "pfitmap_sequences_hmm_profile_id_fkey"
  end

  create_view "hmm_profile_release_statistics", "SELECT dbbp.hmm_profile_id, dbbp.sequence_source_id, ps.pfitmap_release_id, count(*) AS n, min(dbbp.fullseq_score) AS min_fullseq_score, max(dbbp.fullseq_score) AS max_fullseq_score FROM (db_sequence_best_profiles dbbp LEFT JOIN pfitmap_sequences ps ON (((dbbp.db_sequence_id = ps.db_sequence_id) AND (dbbp.hmm_profile_id = ps.hmm_profile_id)))) GROUP BY dbbp.hmm_profile_id, dbbp.sequence_source_id, ps.pfitmap_release_id", :force => true
  create_table "hmm_score_criteria", :force => true do |t|
    t.float    "min_fullseq_score"
    t.integer  "hmm_profile_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.index ["hmm_profile_id"], :name => "index_hmm_score_criterions_on_hmm_profile_id", :order => {"hmm_profile_id" => :asc}
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
    t.index ["sequence_source_id"], :name => "index_pfitmap_releases_on_sequence_source_id", :order => {"sequence_source_id" => :asc}
    t.foreign_key ["sequence_source_id"], "sequence_sources", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "pfitmap_releases_sequence_source_id_fkey"
  end

  create_table "taxons", :force => true do |t|
    t.integer  "ncbi_taxon_id"
    t.boolean  "wgs"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "domain"
    t.string   "kingdom"
    t.string   "phylum"
    t.string   "taxclass"
    t.string   "taxorder"
    t.string   "family"
    t.string   "genus"
    t.string   "species"
    t.string   "strain"
    t.integer  "pfitmap_release_id"
    t.index ["pfitmap_release_id"], :name => "fk__taxons_pfitmap_release_id", :order => {"pfitmap_release_id" => :asc}
    t.index ["ncbi_taxon_id"], :name => "index_taxons_on_ncbi_taxon_id", :unique => true, :order => {"ncbi_taxon_id" => :asc}
    t.index ["domain", "kingdom", "phylum", "taxclass", "taxorder", "family", "genus", "species", "strain"], :name => "taxhierarchy", :unique => true, :order => {"domain" => :asc, "kingdom" => :asc, "phylum" => :asc, "taxclass" => :asc, "taxorder" => :asc, "family" => :asc, "genus" => :asc, "species" => :asc, "strain" => :asc}
    t.foreign_key ["pfitmap_release_id"], "pfitmap_releases", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_taxons_pfitmap_release_id"
  end

  create_table "protein_counts", :force => true do |t|
    t.integer  "no_proteins"
    t.integer  "no_genomes_with_proteins"
    t.integer  "protein_id"
    t.integer  "pfitmap_release_id"
    t.integer  "taxon_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.boolean  "obs_as_genome"
    t.index ["pfitmap_release_id"], :name => "index_protein_counts_on_pfitmap_release_id", :order => {"pfitmap_release_id" => :asc}
    t.index ["protein_id"], :name => "index_protein_counts_on_protein_id", :order => {"protein_id" => :asc}
    t.index ["taxon_id"], :name => "index_protein_counts_on_taxon_id", :order => {"taxon_id" => :asc}
    t.foreign_key ["pfitmap_release_id"], "pfitmap_releases", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "protein_counts_pfitmap_release_id_fkey"
    t.foreign_key ["protein_id"], "proteins", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "protein_counts_protein_id_fkey"
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
