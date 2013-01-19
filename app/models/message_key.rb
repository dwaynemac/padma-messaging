class MessageKey < ActiveRecord::Base
  attr_accessible :name

  validates_uniqueness_of :name

  has_many :app_allowed_keys
  has_many :allowed_apps, through: :app_allowed_keys, class_name: 'App'

  has_many :notify_mes
  has_many :registered_apps, through: :notify_mes, class_name: 'App'

end
