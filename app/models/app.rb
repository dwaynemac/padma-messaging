class App < ActiveRecord::Base
  attr_accessible :app_key, :name

  validates_uniqueness_of :app_key
  validates_uniqueness_of :name

  has_many :app_allowed_keys
  has_many :allowed_message_keys, through: :app_allowed_keys, class_name: 'MessageKey'

  has_many :messages
end
