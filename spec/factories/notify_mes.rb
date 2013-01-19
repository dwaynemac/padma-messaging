# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notify_me do
    message_key
    url "https://anurl.com"
    app
  end
end
