# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    app
    message_key
    data "MyText"
  end
end
