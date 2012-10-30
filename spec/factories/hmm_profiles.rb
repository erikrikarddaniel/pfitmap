FactoryGirl.define do
  factory :hmm_profile do
    sequence(:name){ |n| "Example Class #{n}" }
    sequence(:protein_name) { |n| "NrdX#{n}" }
    sequence(:version) { |n| "version #{n}" }
  end
  
  factory :hmm_profile_nrdbr2lox, class: HmmProfile do
    name "RNR R2 and R2lox"
    protein_name "NrdB:R2lox"
    version "20120401"
  end
                                    
  factory :hmm_profile_nrdb, class: HmmProfile do
    name "Class I RNR radical generating subunit"
    protein_name "NrdB"
    version "20120401"
    parent { |hmm_profile| get_hmm_profile_named(:hmm_profile_nrdbr2lox) }
    after_create do |profile|
          FactoryGirl.create(:hmm_score_criterion, 
                             :hmm_profile => profile,
                             :min_fullseq_score => 400.0)
    end
        
  end
  
  factory :hmm_profile_nrdben, class: HmmProfile do
    name "Class I RNR radical generating subunit, eukaryotes and sister group"
    protein_name "NrdBen"
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
  
  factory :hmm_profile_nrdapfl, class: HmmProfile do
    name "RNR R1 and PFL"
    protein_name "NrdA:PFL"
    version "20120401"
  end

end


# Helper methods to aviod duplicates
def get_hmm_profile_named(factory_name)
  name_hash = { 
    :hmm_profile_nrdbr2lox => "RNR R2 and R2lox", 
    :hmm_profile_nrdb => "Class I RNR radical generating subunit",
    :hmm_profile_nrdben => "Class I RNR radical generating subunit, eukaryotes and sister group",
    :hmm_profile_nrdbe => "Class I RNR radical generating subunit, eukaryotes",
    :hmm_profile_nrdbn => "Class I RNR radical generating subunit, eukaryotic sister-group",
    :hmm_profile_r2lox => "R2lox protein",
    :hmm_profile_nrdapfl => "RNR R1 and PFL"
  }
  HmmProfile.where(:name => name_hash[factory_name]).first || FactoryGirl.create(factory_name)
end
