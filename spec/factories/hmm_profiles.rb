FactoryGirl.define do
  factory :hmm_profile do
    sequence(:name){ |n| "Example Class #{n}" }
    sequence(:protein_name) { |n| "NrdX#{n}" }
    sequence(:version) { |n| "version #{n}" }
  end
  
  factory :hmm_profile_nrdapfl, class: HmmProfile do
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
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrdapfl) }
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
end


# Helper methods to aviod duplicates
def get_hmm_profile_named(factory_name)
  name_hash = { 
    :hmm_profile_nrdapfl => "RNR R1 and PFL",
    :hmm_profile_nrda => "Class I RNR catalytic subunit",
    :hmm_profile_nrdac => "Class Ic RNR catalytic subunit",
    :hmm_profile_nrdae => "Class Ie RNR catalytic subunit",
    :hmm_profile_nrdbr2lox => "RNR R2 and R2lox", 
    :hmm_profile_nrdb => "Class I RNR radical generating subunit",
    :hmm_profile_nrdben => "Class I RNR radical generating subunit, eukaryotes and sister group",
    :hmm_profile_nrdban => "Class I RNR radical generating subunit, eukaryotes and sister group-for sorting test",
    :hmm_profile_nrdbe => "Class I RNR radical generating subunit, eukaryotes",
    :hmm_profile_nrdbn => "Class I RNR radical generating subunit, eukaryotic sister-group",
    :hmm_profile_r2lox => "R2lox protein"
  }
  HmmProfile.where(:name => name_hash[factory_name]).first || FactoryGirl.create(factory_name)
end
