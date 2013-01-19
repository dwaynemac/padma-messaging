# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :app_message_delivery do
    app
    message
    delivered false
  end
end
