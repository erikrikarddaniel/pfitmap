require 'file_parsers'
include FileParsers

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Rake::Task['db:truncate'].invoke
    @dbsequences = {}	# Object hash indexed by acc number
    @hmm_db_hits = {} 	# Object hash indexed by acc number
    make_users
    make_hmm_profiles
    make_sequence_sources
    make_hmm_results
    make_hmm_score_criteria
    make_enzymes
    make_release
  end

  def make_users
    ActiveRecord::Base.connection.execute(<<SQL
INSERT INTO users(provider, uid, name, email, role, created_at, updated_at)
VALUES(
  'open_id',
  'https://www.google.com/accounts/o8/id?id=AItOawn2s8yf5g5eR7cFzieJrUKsHoR4uEt5ILo',
  'Daniel Lundin',
  'daniel.lundin@scilifelab.se',
  'admin',
  now(),
  now()
)
SQL
    )

    ActiveRecord::Base.connection.execute(<<SQL
INSERT INTO users(provider, uid, name, email, role, created_at, updated_at)
VALUES(
  'open_id', 
  'https://www.google.com/accounts/o8/id?id=AItOawm1xNC-6Yy1MPDIIPvX_KrmZ1NNZQKcNgM',
  'Johannes Alneberg',
  'johannesalneberg@gmail.com',
  'admin',
  now(),
  now()
)
SQL
    )
  end

  def make_hmm_profiles
    # RNR R2
    @hmm_profile_nrdbr2lox = HmmProfile.create!(
      name: "RNR R2 and R2lox",
      protein_name: "NrdB-R2lox",
      version: "20120402",
    )
    @hmm_profile_nrdb = HmmProfile.create!(
      name: "RNR R2",
      protein_name: "NrdB",
      version: "20120402",
      parent_id: @hmm_profile_nrdbr2lox.id
    )
    @hmm_profile_nrdf = HmmProfile.create!(
      name: "RNR R2 subclass Ib",
      protein_name: "NrdF",
      version: "20120402",
      parent_id: @hmm_profile_nrdb.id
    )
    @hmm_profile_nrdben = HmmProfile.create!(
      name: "RNR R2, Eukaryotes and sister group",
      protein_name: "NrdBen",
      version: "20120402",
      parent_id: @hmm_profile_nrdb.id
    )
    @hmm_profile_nrdbe = HmmProfile.create!(
      name: "RNR R2, Eukaryotes",
      protein_name: "NrdBe",
      version: "20120402",
      parent_id: @hmm_profile_nrdben.id
    )
    @hmm_profile_r2lox = HmmProfile.create!(
      name: "R2lox",
      protein_name: "R2lox",
      version: "20120402",
      parent_id: @hmm_profile_nrdbr2lox.id
    )

    # RNR R1
    @hmm_profile_nrdpfl = HmmProfile.create!(
      name: "RNR R1 and PFL",
      protein_name: "Nrd-PFL",
      version: "20120402",
    )
    @hmm_profile_nrdaj = HmmProfile.create!(
      name: "RNR class I R1 and class II",
      protein_name: "NrdAJ",
      version: "20120402",
      parent_id: @hmm_profile_nrdpfl.id
    )
    @hmm_profile_nrda = HmmProfile.create!(
      name: "RNR class I R1",
      protein_name: "NrdA",
      version: "20120402",
      parent_id: @hmm_profile_nrdaj.id
    )
    @hmm_profile_nrdac = HmmProfile.create!(
      name: "RNR class Ib R1",
      protein_name: "NrdAc",
      version: "20120402",
      parent_id: @hmm_profile_nrda.id
    )
    @hmm_profile_nrdae = HmmProfile.create!(
      name: "RNR class Ib R1",
      protein_name: "NrdAe",
      version: "20120402",
      parent_id: @hmm_profile_nrda.id
    )
    @hmm_profile_nrde = HmmProfile.create!(
      name: "RNR class Ib R1",
      protein_name: "NrdE",
      version: "20120402",
      parent_id: @hmm_profile_nrda.id
    )
    @hmm_profile_nrdd = HmmProfile.create!(
      name: "RNR class III enzyme",
      protein_name: "NrdD",
      version: "20120402",
      parent_id: @hmm_profile_nrdpfl.id
    )
    @hmm_profile_nrdda = HmmProfile.create!(
      name: "RNR class III enzyme",
      protein_name: "NrdDa",
      version: "20120402",
      parent_id: @hmm_profile_nrdd.id
    )
    @hmm_profile_nrddb = HmmProfile.create!(
      name: "RNR class III enzyme",
      protein_name: "NrdDb",
      version: "20120402",
      parent_id: @hmm_profile_nrdd.id
    )
    @hmm_profile_nrddc = HmmProfile.create!(
      name: "RNR class III enzyme",
      protein_name: "NrdDc",
      version: "20120402",
      parent_id: @hmm_profile_nrdd.id
    )
    @hmm_profile_nrddd = HmmProfile.create!(
      name: "RNR class III enzyme",
      protein_name: "NrdDd",
      version: "20120402",
      parent_id: @hmm_profile_nrdd.id
    )
    @hmm_profile_nrdj = HmmProfile.create!(
      name: "RNR class II",
      protein_name: "NrdJ",
      version: "20120402",
      parent_id: @hmm_profile_nrdaj.id
    )
    @hmm_profile_nrdja = HmmProfile.create!(
      name: "RNR class II",
      protein_name: "NrdJa",
      version: "20120402",
      parent_id: @hmm_profile_nrdj.id
    )
    @hmm_profile_nrdjc = HmmProfile.create!(
      name: "RNR class II",
      protein_name: "NrdJc",
      version: "20120402",
      parent_id: @hmm_profile_nrdj.id
    )
    @hmm_profile_nrdjd = HmmProfile.create!(
      name: "RNR class II",
      protein_name: "NrdJd",
      version: "20120402",
      parent_id: @hmm_profile_nrdj.id
    )
    @hmm_profile_nrdjm = HmmProfile.create!(
      name: "RNR class II",
      protein_name: "NrdJm",
      version: "20120402",
      parent_id: @hmm_profile_nrdj.id
    )
    @hmm_profile_nrdg_pfla = HmmProfile.create!(
      name: "NrdG and PFL activase",
      protein_name: "NrdG-PFLa",
      version: "20120402",
    )
    @hmm_profile_nrdg = HmmProfile.create!(
      name: "NrdG",
      protein_name: "NrdG",
      version: "20120402",
      parent_id: @hmm_profile_nrdg_pfla.id
    )
    @hmm_profile_pfla = HmmProfile.create!(
      name: "PFL activase",
      protein_name: "PFLa",
      version: "20120402",
      parent_id: @hmm_profile_nrdg_pfla.id
    )
  end

  def make_hmm_results
    puts ">>> #{Time.now()}: NrdAc: Importing HMM result <<<"
    @hmm_result_nrdac_nr_april = @hmm_profile_nrdac.hmm_results.create!(
      executed: "2012-08-01 12:00",
      sequence_source_id: @sequence_source_nr_june.id
    )
    parse_hmm_tblout(@hmm_result_nrdac_nr_april, File.new('data/example_data/NrdAc.tblout'))
    puts ">>> #{Time.now()}: NrdAe: Importing HMM result <<<"
    @hmm_result_nrdae_nr_april = @hmm_profile_nrdae.hmm_results.create!(
      executed: "2012-08-01 12:00",
      sequence_source_id: @sequence_source_nr_june.id
    )
    parse_hmm_tblout(@hmm_result_nrdae_nr_april, File.new('data/example_data/NrdAe.tblout'))
    puts ">>> #{Time.now()}: NrdA: Importing HMM result <<<"
    @hmm_result_nrda_nr_april = @hmm_profile_nrda.hmm_results.create!(
      executed: "2012-08-01 12:00",
      sequence_source_id: @sequence_source_nr_june.id
    )
    parse_hmm_tblout(@hmm_result_nrda_nr_april, File.new('data/example_data/NrdA.tblout'))
    puts ">>> #{Time.now()}: NrdBen: Importing HMM result <<<"
    @hmm_result_nrdben_nr_april = @hmm_profile_nrdben.hmm_results.create!(
      executed: "2012-08-01 12:00",
      sequence_source_id: @sequence_source_nr_june.id
    )
    parse_hmm_tblout(@hmm_result_nrdben_nr_april, File.new('data/example_data/NrdBen.tblout'))
    puts ">>> #{Time.now()}: NrdBe: Importing HMM result <<<"
    @hmm_result_nrdbe_nr_april = @hmm_profile_nrdbe.hmm_results.create!(
      executed: "2012-08-01 12:00",
      sequence_source_id: @sequence_source_nr_june.id
    )
    parse_hmm_tblout(@hmm_result_nrdbe_nr_april, File.new('data/example_data/NrdBe.tblout'))
    puts ">>> #{Time.now()}: NrdB: Importing HMM result <<<"
    @hmm_result_nrdb_nr_april = @hmm_profile_nrdb.hmm_results.create!(
      executed: "2012-08-01 12:00",
      sequence_source_id: @sequence_source_nr_june.id
    )
    parse_hmm_tblout(@hmm_result_nrdb_nr_april, File.new('data/example_data/NrdB.tblout'))
    puts ">>> #{Time.now()}: NrdDa: Importing HMM result <<<"
    @hmm_result_nrdda_nr_april = @hmm_profile_nrdda.hmm_results.create!(
      executed: "2012-08-01 12:00",
      sequence_source_id: @sequence_source_nr_june.id
    )
    parse_hmm_tblout(@hmm_result_nrdda_nr_april, File.new('data/example_data/NrdDa.tblout'))
    puts ">>> #{Time.now()}: NrdDb: Importing HMM result <<<"
    @hmm_result_nrddb_nr_april = @hmm_profile_nrddb.hmm_results.create!(
      executed: "2012-08-01 12:00",
      sequence_source_id: @sequence_source_nr_june.id
    )
    parse_hmm_tblout(@hmm_result_nrddb_nr_april, File.new('data/example_data/NrdDb.tblout'))
    puts ">>> #{Time.now()}: NrdDc: Importing HMM result <<<"
    @hmm_result_nrddc_nr_april = @hmm_profile_nrddc.hmm_results.create!(
      executed: "2012-08-01 12:00",
      sequence_source_id: @sequence_source_nr_june.id
    )
    parse_hmm_tblout(@hmm_result_nrddc_nr_april, File.new('data/example_data/NrdDc.tblout'))
    puts ">>> #{Time.now()}: NrdDd: Importing HMM result <<<"
    @hmm_result_nrddd_nr_april = @hmm_profile_nrddd.hmm_results.create!(
      executed: "2012-08-01 12:00",
      sequence_source_id: @sequence_source_nr_june.id
    )
    parse_hmm_tblout(@hmm_result_nrddd_nr_april, File.new('data/example_data/NrdDd.tblout'))
    puts ">>> #{Time.now()}: NrdD: Importing HMM result <<<"
    @hmm_result_nrdd_nr_april = @hmm_profile_nrdd.hmm_results.create!(
      executed: "2012-08-01 12:00",
      sequence_source_id: @sequence_source_nr_june.id
    )
    parse_hmm_tblout(@hmm_result_nrdd_nr_april, File.new('data/example_data/NrdD.tblout'))
    puts ">>> #{Time.now()}: NrdE: Importing HMM result <<<"
    @hmm_result_nrde_nr_april = @hmm_profile_nrde.hmm_results.create!(
      executed: "2012-08-01 12:00",
      sequence_source_id: @sequence_source_nr_june.id
    )
    parse_hmm_tblout(@hmm_result_nrde_nr_april, File.new('data/example_data/NrdE.tblout'))
    puts ">>> #{Time.now()}: NrdF: Importing HMM result <<<"
    @hmm_result_nrdf_nr_april = @hmm_profile_nrdf.hmm_results.create!(
      executed: "2012-08-01 12:00",
      sequence_source_id: @sequence_source_nr_june.id
    )
    parse_hmm_tblout(@hmm_result_nrdf_nr_april, File.new('data/example_data/NrdF.tblout'))
    puts ">>> #{Time.now()}: NrdJa: Importing HMM result <<<"
    @hmm_result_nrdja_nr_april = @hmm_profile_nrdja.hmm_results.create!(
      executed: "2012-08-01 12:00",
      sequence_source_id: @sequence_source_nr_june.id
    )
    parse_hmm_tblout(@hmm_result_nrdja_nr_april, File.new('data/example_data/NrdJa.tblout'))
    puts ">>> #{Time.now()}: NrdJc: Importing HMM result <<<"
    @hmm_result_nrdjc_nr_april = @hmm_profile_nrdjc.hmm_results.create!(
      executed: "2012-08-01 12:00",
      sequence_source_id: @sequence_source_nr_june.id
    )
    parse_hmm_tblout(@hmm_result_nrdjc_nr_april, File.new('data/example_data/NrdJc.tblout'))
    puts ">>> #{Time.now()}: NrdJd: Importing HMM result <<<"
    @hmm_result_nrdjd_nr_april = @hmm_profile_nrdjd.hmm_results.create!(
      executed: "2012-08-01 12:00",
      sequence_source_id: @sequence_source_nr_june.id
    )
    parse_hmm_tblout(@hmm_result_nrdjd_nr_april, File.new('data/example_data/NrdJd.tblout'))
    puts ">>> #{Time.now()}: NrdJm: Importing HMM result <<<"
    @hmm_result_nrdjm_nr_april = @hmm_profile_nrdjm.hmm_results.create!(
      executed: "2012-08-01 12:00",
      sequence_source_id: @sequence_source_nr_june.id
    )
    parse_hmm_tblout(@hmm_result_nrdjm_nr_april, File.new('data/example_data/NrdJm.tblout'))
    puts ">>> #{Time.now()}: NrdJ: Importing HMM result <<<"
    @hmm_result_nrdj_nr_april = @hmm_profile_nrdj.hmm_results.create!(
      executed: "2012-08-01 12:00",
      sequence_source_id: @sequence_source_nr_june.id
    )
    parse_hmm_tblout(@hmm_result_nrdj_nr_april, File.new('data/example_data/NrdJ.tblout'))
    puts ">>> #{Time.now()}: NrdGPFLa: Importing HMM result <<<"
    @hmm_result_nrdg_pfla_nr_april = @hmm_profile_nrdg_pfla.hmm_results.create!(
      executed: "2012-08-01 12:00",
      sequence_source_id: @sequence_source_nr_june.id
    )
    parse_hmm_tblout(@hmm_result_nrdg_pfla_nr_april, File.new('data/example_data/NrdGPFLa.tblout'))
  end

  def make_hmm_score_criteria
    HmmScoreCriterion.create!(hmm_profile_id: @hmm_profile_nrda.id, min_fullseq_score: 1000)
    HmmScoreCriterion.create!(hmm_profile_id: @hmm_profile_nrdac.id, min_fullseq_score: 1000)
    HmmScoreCriterion.create!(hmm_profile_id: @hmm_profile_nrdae.id, min_fullseq_score: 1000)
    HmmScoreCriterion.create!(hmm_profile_id: @hmm_profile_nrde.id, min_fullseq_score: 1000)
    HmmScoreCriterion.create!(hmm_profile_id: @hmm_profile_nrdb.id, min_fullseq_score: 400)
    HmmScoreCriterion.create!(hmm_profile_id: @hmm_profile_nrdbe.id, min_fullseq_score: 400)
    HmmScoreCriterion.create!(hmm_profile_id: @hmm_profile_nrdben.id, min_fullseq_score: 400)
    HmmScoreCriterion.create!(hmm_profile_id: @hmm_profile_nrdd.id, min_fullseq_score: 1000)
    HmmScoreCriterion.create!(hmm_profile_id: @hmm_profile_nrdda.id, min_fullseq_score: 1000)
    HmmScoreCriterion.create!(hmm_profile_id: @hmm_profile_nrddb.id, min_fullseq_score: 1000)
    HmmScoreCriterion.create!(hmm_profile_id: @hmm_profile_nrddc.id, min_fullseq_score: 1000)
    HmmScoreCriterion.create!(hmm_profile_id: @hmm_profile_nrddd.id, min_fullseq_score: 1000)
    HmmScoreCriterion.create!(hmm_profile_id: @hmm_profile_nrdf.id, min_fullseq_score: 400)
    HmmScoreCriterion.create!(hmm_profile_id: @hmm_profile_nrdg.id, min_fullseq_score: 200)
    HmmScoreCriterion.create!(hmm_profile_id: @hmm_profile_nrdj.id, min_fullseq_score: 800)
    HmmScoreCriterion.create!(hmm_profile_id: @hmm_profile_nrdja.id, min_fullseq_score: 800)
    HmmScoreCriterion.create!(hmm_profile_id: @hmm_profile_nrdjc.id, min_fullseq_score: 800)
    HmmScoreCriterion.create!(hmm_profile_id: @hmm_profile_nrdjd.id, min_fullseq_score: 800)
    HmmScoreCriterion.create!(hmm_profile_id: @hmm_profile_nrdjm.id, min_fullseq_score: 800)
    HmmScoreCriterion.create!(hmm_profile_id: @hmm_profile_nrdpfl.id, min_fullseq_score: 1000)
    HmmScoreCriterion.create!(hmm_profile_id: @hmm_profile_pfla.id, min_fullseq_score: 200)
    HmmScoreCriterion.create!(hmm_profile_id: @hmm_profile_r2lox.id, min_fullseq_score: 350)
  end

  def make_sequence_sources
    @sequence_source_nr_april = SequenceSource.create!(name: "NR", source: "NCBI", version: "2012-04-01")
    @sequence_source_nr_june = SequenceSource.create!(name: "NR", source: "NCBI", version: "2012-06-24")
  end

  def make_enzymes
    @enzyme_class_i_rnr = Enzyme.create!(
      name: 'RNR class I enzyme'
    )
    ep = @hmm_profile_nrdb.enzyme_profiles.create!
    ep.enzyme_id = @enzyme_class_i_rnr.id
    ep.save
    ep = @hmm_profile_nrda.enzyme_profiles.create!
    ep.enzyme_id = @enzyme_class_i_rnr.id
    ep.save
    @enzyme_class_ib_rnr = Enzyme.create!(
      name: 'RNR class Ib enzyme'
    )
    ep = @hmm_profile_nrdf.enzyme_profiles.create!
    ep.enzyme_id = @enzyme_class_ib_rnr.id
    ep.save
    ep = @hmm_profile_nrde.enzyme_profiles.create!
    ep.enzyme_id = @enzyme_class_ib_rnr.id
    ep.save
    @enzyme_class_ii_rnr = Enzyme.create!(
      name: 'RNR class II enzyme'
    )
    ep = @hmm_profile_nrdj.enzyme_profiles.create!
    ep.enzyme_id = @enzyme_class_ii_rnr.id
    ep.save
    @enzyme_class_iii_rnr = Enzyme.create!(
      name: 'RNR class III enzyme'
    )
    ep = @hmm_profile_nrdd.enzyme_profiles.create!
    ep.enzyme_id = @enzyme_class_iii_rnr.id
    ep.save
    ep = @hmm_profile_nrdg.enzyme_profiles.create!
    ep.enzyme_id = @enzyme_class_iii_rnr.id
    ep.save
  end

  def make_release 
     pr = PfitmapRelease.new(
	  sequence_source_id: @sequence_source_nr_june.id,
	  release: "0.1",
	  release_date: "2012-06-13"
	)
	
     pr.current = false
     pr.save
  end
end
