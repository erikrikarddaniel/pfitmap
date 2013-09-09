FactoryGirl.define do

  factory :hmm_score_criterion do
    hmm_profile
    min_fullseq_score 15.0
  end
  
  factory :sequence_source do
    source "NCBI"
    name "NR"
    version "20120328"
  end
  
  factory :sequence_source_older, class: SequenceSource do
    source "NCBI"
    name "NR"
    version "20120128"
  end

  factory :db_sequence do
  end
  
  factory :db_entry, class: DbEntry do
    sequence(:gi){|n| n}
    db "ref"
    desc "This is an example entry"
    db_sequence
  end

  factory :db_entry_pdb, class: DbEntry do
    gi '13'
    db 'pdb'
    acc '1mxl'
    desc 'An example PDB hit'
    db_sequence
  end
  
  factory :hmm_result_row, class: HmmResultRow do
    hmm_result
    target_name "gi|160942848|ref|ZP_02090088.1|"
    fullseq_evalue 3e-300
    fullseq_score 50.0
    db_sequence
  end
  
  factory :hmm_result_row2, class: HmmResultRow do
    hmm_result
    target_name "gi|167748341|ref|ZP_02420468.1|"
    fullseq_evalue 4e-100
    fullseq_score 10.0
    db_sequence
  end

  factory :hmm_alignment do
    hmm_result_row
    score 365.5
    cevalue 6.1e-110
    hmmfrom 13
    hmmto 349
    alifrom 3
    alito 343
    envfrom 1
    envto 346
    acc 0.98
    hmm_line "kakkleeesqkeeekkepllsgenlsrvnlnpikypwakefykkaeanfWlpeeidlsdDikdWktLseeerrlikrvlafltllDtivgenlvealsqeitapeakavlgfqafmEaiHaksYsliletlgtdeeidelFdavrenpalqkKaef"
    match_line  "k+k+l++++ + +++ +++  g++++ +++n++ky w+ ++y++a++nfW+peei+ls+D+kd+  L  +er +++++l+fl +lD+i++ nl  ++  +ita+e++ +l+ qaf+E +H++sYs++l+t++++ e++++  +++++++l ++++f"
    target_line "KKKPLFNPEGDPDVRLRRMTGGNTTNLNDFNNMKYAWVSDWYRQAMNNFWIPEEINLSQDVKDYPRLLSAERSAYDKILSFLVFLDSIQTANLP-NIGAYITANEVNLCLSIQAFQECVHSQSYSYMLDTICSPVERNDILYQWKTDEHLLRRNTF"
    pp_line     "5667899999999*********************************************************************************.*************************************************************"
  end

  factory :pfitmap_sequence do
    db_sequence
    pfitmap_release
    hmm_profile
  end

  factory :pfitmap_release do
    sequence(:release) { |n|  (0.0 + 0.1*n - 0.01*n).to_s }
    sequence(:release_date) { |n| (Date.new(2012,01,01) + n.days).to_s }
    current "false"
    sequence_source
  end

  factory :user do
    provider "open_id"
    uid "ex123456"
    name "johannes"
    email "jorasaatte@gmail.com"
    role "guest"
  end

  factory :user_admin, class: User do
    provider "open_id"
    uid "ex1236"
    name "Bob"
    email "bob@example.com"
    role "admin"
  end 

  factory :enzyme do
    name "Example ENZ"
    abbreviation "ENZ"
  end

  factory :enzyme_row, class: Enzyme do
    name "Example row enzyme"
    abbreviation "RENZ"
    enzymeclass "EnzClass"
    subclass "EnzSubClass"
    group "EnzGroup"
    subgroup "EnzSubGroup"
    subsubgroup "EnzSubSubGroup"
  end

  factory :taxon do |t|
    sequence(:name) { |n|  "example_taxon_name " + n.to_s }
    sequence(:ncbi_taxon_id) { |n| n} 
  end
  factory :taxon_flat do |t|
    sequence(:ncbi_taxon_id) {|n| n}
  end
  factory :protein do
    sequence(:name) { |n| "ex_protein " + n.to_s }
    hmm_profile
 end

  factory :protein_count do
    no_genomes 1
    no_proteins 0
    no_genomes_with_proteins 0
    protein
    pfitmap_release
    taxon
  end

end
