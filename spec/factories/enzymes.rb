FactoryGirl.define do
  factory :enzyme_class_1, class: Enzyme do
    name "RNR class I enzyme"
    abbreviation "RNR I"
  end

  factory :enzyme_class_2, class: Enzyme do
    name "RNR class II enzyme"
    abbreviation "RNR III"
  end

  factory :enzyme_class_3, class: Enzyme do
    name "RNR class III enzyme"
    abbreviation "RNR III"
  end

  factory :enzyme_class_1b, class: Enzyme do
    name "RNR class Ib enzyme"
    abbreviation "RNR Ib"
  end

  factory :enzyme_class_1c, class: Enzyme do
    name "RNR class Ic enzyme"
    abbreviation "RNR Ic"
  end
end
