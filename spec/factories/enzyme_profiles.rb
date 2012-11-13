FactoryGirl.define do
  factory :enzyme_profile do
      enzyme
      hmm_profile
  end
end

def create_enzymes_for_profile(factory_name)
  profile = get_hmm_profile_named(factory_name)
  enzyme_name_hash = {
    :hmm_profile_nrdb => ["RNR class I enzyme"]
  }
  enzyme_factory_hash = {
    "RNR class I enzyme" => :enzyme_class_1
  }
  enzyme_list = enzyme_name_hash[factory_name]
  if enzyme_list
    enzyme_list.each do |enzyme_name|
      enzyme = Enzyme.where(:name => enzyme_name).first || 
        FactoryGirl.create(enzyme_factory_hash[enzyme_name])
      FactoryGirl.create(:enzyme_profile, enzyme: enzyme, hmm_profile: profile)
    end
  end
end
