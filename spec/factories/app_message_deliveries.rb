# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :app_message_delivery do
    app_id 1
    message_id 1
    delivered false
  end
end
