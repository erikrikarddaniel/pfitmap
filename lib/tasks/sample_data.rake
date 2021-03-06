require 'file_parsers'
include FileParsers

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Rake::Task['db:truncate'].invoke
    @dbsequences = {}	# Object hash indexed by acc number
    @db_entries = {} 	# Object hash indexed by acc number
    make_users
    make_hmm_profiles
    make_sequence_sources
    make_enzymes
    make_release
    make_hmm_score_criteria
    make_hmm_results
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
    ActiveRecord::Base.connection.execute(<<SQL
INSERT INTO users(provider, uid, name, email, role, created_at, updated_at)
VALUES(
  'open_id', 
  'https://www.google.com/accounts/o8/id?id=AItOawlN94VEQwqUCD7g106aeMebnRpOlLYmGos',
  'Brynjar Smari Bjarnason',
  'binni@binnisb.com',
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
    @hmm_profile_nrdj = HmmProfile.create!(
      name: "RNR class II",
      protein_name: "NrdJ",
      version: "20120402",
      parent_id: @hmm_profile_nrdaj.id
    )
    # Make some subprofiles
    %w[ Ae Ac Da Db Dc Dd Dd0 Dd1 Dd2 Ja Jc Jd Jm ].each do |c|
      str = %(@hmm_profile_nrd#{c.downcase} = HmmProfile.create!(
	name: "RNR Nrd#{c} protein",
	protein_name: "NrdD#{c}",
	version: "20120402",
	parent_id: @hmm_profile_nrd#{c[0..-2].downcase}.id
      ))
      eval str
    end
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
    %w[ A Ac Ae Ben Be B Da Db Dc Dd Dd0 Dd1 Dd2 D E F Ja Jc Jd Jm J ].each do |c|
      str = %(puts "*** #{Time.now()}: Nrd#{c}: Importing HMM result ***"
      @hmm_result_nrd#{c.downcase}_nr_april = @hmm_profile_nrd#{c.downcase}.hmm_results.create!(
	executed: "2012-08-01 12:00",
	sequence_source_id: @sequence_source_nr_june.id
      )
      puts "\t--> .tblout file <--"
      parse_hmm_tblout(@hmm_result_nrd#{c.downcase}_nr_april, File.new('data/example_data/Nrd#{c}.tblout'))
      puts "\t--> .hmmout file <--"
      parse_hmmout(@hmm_result_nrd#{c.downcase}_nr_april, File.new('data/example_data/Nrd#{c}.hmmout')))
      eval str
    end
  end

  def make_hmm_score_criteria
    %w[ a ac ae e d da db dc dd dd0 dd1 dd2 pfl ].each do |c|
      _add_score_criterion("nrd#{c}", 1000)
    end
    %w[ j ja jc jd jm ].each do |c|
      _add_score_criterion("nrd#{c}", 800)
    end
    %w[ b be ben f ].each do |c|
      _add_score_criterion("nrd#{c}", 400)
    end
    %w[ g ].each do |c|
      _add_score_criterion("nrd#{c}", 200)
    end
    _add_score_criterion("pfla", 200)
    _add_score_criterion("r2lox", 350)
  end

  def make_sequence_sources
    @sequence_source_nr_april = SequenceSource.create!(name: "NR", source: "NCBI", version: "2012-04-01")
    @sequence_source_nr_june = SequenceSource.create!(name: "NR", source: "NCBI", version: "2012-06-24")
  end

  def make_enzymes
    @enzyme_class_i_rnr = Enzyme.create!(
      name: 'RNR class I enzyme',
      abbreviation: 'RNR I'
    )
    ep = @hmm_profile_nrdb.enzyme_profiles.create!
    ep.enzyme_id = @enzyme_class_i_rnr.id
    ep.save
    ep = @hmm_profile_nrda.enzyme_profiles.create!
    ep.enzyme_id = @enzyme_class_i_rnr.id
    ep.save
    @enzyme_class_ib_rnr = @enzyme_class_i_rnr.children.create!(
      name: 'RNR class Ib enzyme',
      abbreviation: 'RNR Ib'
    )
    ep = @hmm_profile_nrdf.enzyme_profiles.create!
    ep.enzyme_id = @enzyme_class_ib_rnr.id
    ep.save
    ep = @hmm_profile_nrde.enzyme_profiles.create!
    ep.enzyme_id = @enzyme_class_ib_rnr.id
    ep.save
    @enzyme_class_ii_rnr = Enzyme.create!(
      name: 'RNR class II enzyme',
      abbreviation: 'RNR II'
    )
    ep = @hmm_profile_nrdj.enzyme_profiles.create!
    ep.enzyme_id = @enzyme_class_ii_rnr.id
    ep.save
    @enzyme_class_iii_rnr = Enzyme.create!(
      name: 'RNR class III enzyme',
      abbreviation: 'RNR III'
    )
    ep = @hmm_profile_nrdd.enzyme_profiles.create!
    ep.enzyme_id = @enzyme_class_iii_rnr.id
    ep.save
    ep = @hmm_profile_nrdg.enzyme_profiles.create!
    ep.enzyme_id = @enzyme_class_iii_rnr.id
    ep.save
    %w[ a b c d d0 d1 d2 ].each do |c|
      str = "@enzyme_class_iii#{c}_rnr = @enzyme_class_iii#{c[0..-2]}_rnr.children.create!(
	name: \"RNR subclass III#{c} enzyme\", abbreviation: \"RNR III#{c}\")
	ep = @hmm_profile_nrdd#{c}.enzyme_profiles.create!
	ep.enzyme_id = @enzyme_class_iii#{c}_rnr.id
	ep.save
	ep = @hmm_profile_nrdg.enzyme_profiles.create!
	ep.enzyme_id = @enzyme_class_iii#{c}_rnr.id
	ep.save
      "
      eval(str)
    end
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

private

  def _add_score_criterion(profile, score)
    eval %(HmmScoreCriterion.create!(hmm_profile_id: @hmm_profile_#{profile}.id, min_fullseq_score: #{score}))
  end
end
