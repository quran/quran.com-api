FactoryGirl.define do
  factory :word do
    sequence(:position)
  end

  factory :language do
    sequence(:name)
    sequence(:iso_code)
  end
end