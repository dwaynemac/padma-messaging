# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  sequence :app_names do |n|
    "app_name#{n}"
  end

  sequence :app_keys do |n|
    "secret#{n}"
  end

  factory :app do
    name  { FactoryGirl.generate(:app_names) }
    app_key { FactoryGirl.generate(:app_keys) }
  end
end
