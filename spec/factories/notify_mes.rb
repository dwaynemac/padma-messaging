# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notify_me do
    message_key_id 1
    url "MyString"
    app_id 1
  end
end
