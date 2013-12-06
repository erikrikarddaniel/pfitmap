FactoryGirl.define do
  factory :hmm_profile do
    sequence(:name){ |n| "Example Class #{n}" }
    sequence(:protein_name) { |n| "NrdX#{n}" }
    sequence(:version) { |n| "version #{n}" }
  end
  
  factory :hmm_profile_nrdpfl, class: HmmProfile do
    name "RNR R1 and PFL"
    protein_name "NrdA:PFL"
    rank "protfamily"
    version "20120401"
  end
                                    
  factory :hmm_profile_nrda, class: HmmProfile do
    name "Class I RNR catalytic subunit"
    protein_name "NrdA"
    rank "protclass"
    version "20120401"
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrdpfl) }
    after_create do |profile|
      create_enzymes_for_profile(:hmm_profile_nrda)
      FactoryGirl.create(:hmm_score_criterion, :hmm_profile => profile, :min_fullseq_score => 400.0)
    end
  end
                                    
  factory :hmm_profile_nrdac, class: HmmProfile do
    name "Class Ic RNR catalytic subunit"
    protein_name "NrdAc"
    rank "protclass"
    version "20120401"
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrda) }
    after_create do |profile|
      create_enzymes_for_profile(:hmm_profile_nrdac)
      FactoryGirl.create(:hmm_score_criterion, :hmm_profile => profile, :min_fullseq_score => 400.0)
    end
  end
  
  factory :hmm_profile_nrdae, class: HmmProfile do
    name "Class Ie RNR catalytic subunit"
    protein_name "NrdAe"
    rank "protclass"
    version "20120401"
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrda) }
    after_create do |profile|
      create_enzymes_for_profile(:hmm_profile_nrdae)
      FactoryGirl.create(:hmm_score_criterion, :hmm_profile => profile, :min_fullseq_score => 400.0)
    end
  end
  
  factory :hmm_profile_nrdbr2lox, class: HmmProfile do
    name "RNR R2 and R2lox"
    protein_name "NrdB:R2lox"
    rank "protfamily"
    version "20120401"
  end
                                    
  factory :hmm_profile_nrdb, class: HmmProfile do
    name "Class I RNR radical generating subunit"
    protein_name "NrdB"
    rank "protclass"
    version "20120401"
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrdbr2lox) }
    after_create do |profile|
          create_enzymes_for_profile(:hmm_profile_nrdb)
          FactoryGirl.create(:hmm_score_criterion, 
                             :hmm_profile => profile,
                             :min_fullseq_score => 400.0)
    end
        
  end
  
  factory :hmm_profile_nrdben, class: HmmProfile do
    name "Class I RNR radical generating subunit, eukaryotes and sister group"
    protein_name "NrdBen"
    rank "group"
    version "20120401"
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrdb) }
    after_create do |profile|
      FactoryGirl.create(:hmm_score_criterion, 
                         :hmm_profile => profile,
                         :min_fullseq_score => 400.0)
    end
  end
  
  factory :hmm_profile_nrdban, class: HmmProfile do
    name "Class I RNR radical generating subunit, eukaryotes and sister group-test sorting"
    protein_name "NrdBan"
    rank "group"
    version "20120401"
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrdb) }
    after_create do |profile|
      FactoryGirl.create(:hmm_score_criterion, 
                         :hmm_profile => profile,
                         :min_fullseq_score => 400.0)
    end
  end
  
  factory :hmm_profile_nrdbe, class: HmmProfile do
    name "Class I RNR radical generating subunit, eukaryotes"
    protein_name "NrdBe"
    rank "subclass"
    version "20120401"
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrdben) }
    after_create do |profile|
          FactoryGirl.create(:hmm_score_criterion, 
                             :hmm_profile => profile,
                             :min_fullseq_score => 400.0)
    end
  end
  
  factory :hmm_profile_nrdbn, class: HmmProfile do
    name "Class I RNR radical generating subunit, eukaryotic sister-group"
    protein_name "NrdBn"
    rank "subclass"
    version "20120401"
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrdben) }
    after_create do |profile|
          FactoryGirl.create(:hmm_score_criterion, 
                             :hmm_profile => profile,
                             :min_fullseq_score => 400.0)
    end
  end
  
  factory :hmm_profile_r2lox, class: HmmProfile do
    name "R2lox protein"
    protein_name "R2lox"
    version "20120401"
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrdbr2lox) }
  end
                                    
  factory :hmm_profile_nrdd, class: HmmProfile do
    name "Class III RNR catalytic subunit"
    protein_name "NrdD"
    rank "protclass"
    version "20120401"
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrdpfl) }
    after_create do |profile|
      create_enzymes_for_profile(:hmm_profile_nrdd)
      FactoryGirl.create(:hmm_score_criterion, :hmm_profile => profile, :min_fullseq_score => 400.0)
    end
  end
                                    
  factory :hmm_profile_nrdda, class: HmmProfile do
    name "Class IIIa RNR catalytic subunit"
    protein_name "NrdDa"
    rank "protclass"
    version "20120401"
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrdd) }
    after_create do |profile|
      create_enzymes_for_profile(:hmm_profile_nrdda)
      FactoryGirl.create(:hmm_score_criterion, :hmm_profile => profile, :min_fullseq_score => 400.0)
    end
  end
                                    
  factory :hmm_profile_nrddb, class: HmmProfile do
    name "Class IIIb RNR catalytic subunit"
    protein_name "NrdDb"
    rank "protclass"
    version "20120401"
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrdd) }
    after_create do |profile|
      create_enzymes_for_profile(:hmm_profile_nrddb)
      FactoryGirl.create(:hmm_score_criterion, :hmm_profile => profile, :min_fullseq_score => 400.0)
    end
  end
                                    
  factory :hmm_profile_nrddc, class: HmmProfile do
    name "Class IIIc RNR catalytic subunit"
    protein_name "NrdDc"
    rank "protclass"
    version "20120401"
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrdd) }
    after_create do |profile|
      create_enzymes_for_profile(:hmm_profile_nrddc)
      FactoryGirl.create(:hmm_score_criterion, :hmm_profile => profile, :min_fullseq_score => 400.0)
    end
  end

  factory :hmm_profile_nrddc1, class: HmmProfile do
    name "Class IIIc1 RNR catalytic subunit"
    protein_name "NrdDc1"
    rank "protclass"
    version "20120401"
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrddc) }
    after_create do |profile|
      create_enzymes_for_profile(:hmm_profile_nrddc1)
      FactoryGirl.create(:hmm_score_criterion, :hmm_profile => profile, :min_fullseq_score => 400.0)
    end
  end
                                    
  factory :hmm_profile_nrddc2, class: HmmProfile do
    name "Class IIIc2 RNR catalytic subunit"
    protein_name "NrdDc2"
    rank "protclass"
    version "20120401"
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrddc) }
    after_create do |profile|
      create_enzymes_for_profile(:hmm_profile_nrddc2)
      FactoryGirl.create(:hmm_score_criterion, :hmm_profile => profile, :min_fullseq_score => 400.0)
    end
  end
                                    
                                    
  factory :hmm_profile_nrddd, class: HmmProfile do
    name "Class IIId RNR catalytic subunit"
    protein_name "NrdDd"
    rank "protclass"
    version "20120401"
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrdd) }
    after_create do |profile|
      create_enzymes_for_profile(:hmm_profile_nrddd)
      FactoryGirl.create(:hmm_score_criterion, :hmm_profile => profile, :min_fullseq_score => 400.0)
    end
  end

  factory :hmm_profile_nrddd1, class: HmmProfile do
    name "Class IIId1 RNR catalytic subunit"
    protein_name "NrdDd1"
    rank "protclass"
    version "20120401"
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrddd) }
    after_create do |profile|
      create_enzymes_for_profile(:hmm_profile_nrddd1)
      FactoryGirl.create(:hmm_score_criterion, :hmm_profile => profile, :min_fullseq_score => 400.0)
    end
  end
                                    
  factory :hmm_profile_nrddd1a, class: HmmProfile do
    name "Class IIId1a RNR catalytic subunit"
    protein_name "NrdDd1a"
    rank "protclass"
    version "20120401"
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrddd1) }
    after_create do |profile|
      create_enzymes_for_profile(:hmm_profile_nrddd1a)
      FactoryGirl.create(:hmm_score_criterion, :hmm_profile => profile, :min_fullseq_score => 400.0)
    end
  end
                                    
  factory :hmm_profile_nrddd2, class: HmmProfile do
    name "Class IIId2 RNR catalytic subunit"
    protein_name "NrdDd2"
    rank "protclass"
    version "20120401"
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrddd) }
    after_create do |profile|
      create_enzymes_for_profile(:hmm_profile_nrddd2)
      FactoryGirl.create(:hmm_score_criterion, :hmm_profile => profile, :min_fullseq_score => 400.0)
    end
  end
                                    
  factory :hmm_profile_nrddd3, class: HmmProfile do
    name "Class IIId3 RNR catalytic subunit"
    protein_name "NrdDd3"
    rank "protclass"
    version "20120401"
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrddd) }
    after_create do |profile|
      create_enzymes_for_profile(:hmm_profile_nrddd3)
      FactoryGirl.create(:hmm_score_criterion, :hmm_profile => profile, :min_fullseq_score => 400.0)
    end
  end

  factory :hmm_profile_nrddh, class: HmmProfile do
    name "Class IIIh RNR catalytic subunit"
    protein_name "NrdDh"
    rank "protclass"
    version "20120401"
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrdd) }
    after_create do |profile|
      create_enzymes_for_profile(:hmm_profile_nrddh)
      FactoryGirl.create(:hmm_score_criterion, :hmm_profile => profile, :min_fullseq_score => 400.0)
    end
  end

  factory :hmm_profile_nrddh1, class: HmmProfile do
    name "Class IIIh1 RNR catalytic subunit"
    protein_name "NrdDh1"
    rank "protclass"
    version "20120401"
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrddh) }
    after_create do |profile|
      create_enzymes_for_profile(:hmm_profile_nrddh1)
      FactoryGirl.create(:hmm_score_criterion, :hmm_profile => profile, :min_fullseq_score => 400.0)
    end
  end
                                    
  factory :hmm_profile_nrddh2, class: HmmProfile do
    name "Class IIIh2 RNR catalytic subunit"
    protein_name "NrdDh2"
    rank "protclass"
    version "20120401"
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrddh) }
    after_create do |profile|
      create_enzymes_for_profile(:hmm_profile_nrddh2)
      FactoryGirl.create(:hmm_score_criterion, :hmm_profile => profile, :min_fullseq_score => 400.0)
    end
  end
                                    
  factory :hmm_profile_nrddh3, class: HmmProfile do
    name "Class IIIh3 RNR catalytic subunit"
    protein_name "NrdDh3"
    rank "protclass"
    version "20120401"
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrddh) }
    after_create do |profile|
      create_enzymes_for_profile(:hmm_profile_nrddh3)
      FactoryGirl.create(:hmm_score_criterion, :hmm_profile => profile, :min_fullseq_score => 400.0)
    end
  end
                                    
  factory :hmm_profile_nrddh4, class: HmmProfile do
    name "Class IIIh4 RNR catalytic subunit"
    protein_name "NrdDh4"
    rank "protclass"
    version "20120401"
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrddh) }
    after_create do |profile|
      create_enzymes_for_profile(:hmm_profile_nrddh4)
      FactoryGirl.create(:hmm_score_criterion, :hmm_profile => profile, :min_fullseq_score => 400.0)
    end
  end
end

# Helper methods to aviod duplicates
def get_hmm_profile_named(factory_name)
  name_hash = { 
    :hmm_profile_nrdpfl => "RNR R1 and PFL",
    :hmm_profile_nrda => "Class I RNR catalytic subunit",
    :hmm_profile_nrdac => "Class Ic RNR catalytic subunit",
    :hmm_profile_nrdae => "Class Ie RNR catalytic subunit",
    :hmm_profile_nrdbr2lox => "RNR R2 and R2lox", 
    :hmm_profile_nrdb => "Class I RNR radical generating subunit",
    :hmm_profile_nrdben => "Class I RNR radical generating subunit, eukaryotes and sister group",
    :hmm_profile_nrdban => "Class I RNR radical generating subunit, eukaryotes and sister group-for sorting test",
    :hmm_profile_nrdbe => "Class I RNR radical generating subunit, eukaryotes",
    :hmm_profile_nrdbn => "Class I RNR radical generating subunit, eukaryotic sister-group",
    :hmm_profile_r2lox => "R2lox protein",
    :hmm_profile_nrdd => "Class III RNR catalytic subunit",
    :hmm_profile_nrdda => "Class IIIa RNR catalytic subunit",
    :hmm_profile_nrddb => "Class IIIb RNR catalytic subunit",
    :hmm_profile_nrddc => "Class IIIc RNR catalytic subunit",
    :hmm_profile_nrddc1 => "Class IIIc1 RNR catalytic subunit",
    :hmm_profile_nrddc2 => "Class IIIc2 RNR catalytic subunit",
    :hmm_profile_nrddd => "Class IIId RNR catalytic subunit",
    :hmm_profile_nrddd1 => "Class IIId1 RNR catalytic subunit",
    :hmm_profile_nrddd1a => "Class IIId1a RNR catalytic subunit",
    :hmm_profile_nrddd2 => "Class IIId2 RNR catalytic subunit",
    :hmm_profile_nrddd3 => "Class IIId3 RNR catalytic subunit",
    :hmm_profile_nrddh => "Class IIIh RNR catalytic subunit",
    :hmm_profile_nrddh1 => "Class IIIh1 RNR catalytic subunit",
    :hmm_profile_nrddh2 => "Class IIIh2 RNR catalytic subunit",
    :hmm_profile_nrddh3 => "Class IIIh3 RNR catalytic subunit",
    :hmm_profile_nrddh4 => "Class IIIh4 RNR catalytic subunit"
  }
  HmmProfile.where(:name => name_hash[factory_name]).first || FactoryGirl.create(factory_name)
end
