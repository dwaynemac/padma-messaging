# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :names do |n|
    "key#{n}"
  end

  factory :message_key do
    name {generate(:names)}
  end
end
