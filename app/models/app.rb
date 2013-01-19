class App < ActiveRecord::Base
  attr_accessible :app_key, :name

  validates_uniqueness_of :app_key
  validates_uniqueness_of :name

  has_many :app_allowed_keys, dependent: :destroy
  has_many :allowed_message_keys, through: :app_allowed_keys, class_name: 'MessageKey', source: :message_key

  has_many :messages

  has_many :notify_mes, dependent: :destroy
  has_many :registered_keys, through: :notify_mes, class_name: 'MessageKey', source: :message_key
end
