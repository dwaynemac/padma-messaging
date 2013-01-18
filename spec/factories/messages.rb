# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    app_id 1
    message_key_id 1
    data "MyText"
  end
end
