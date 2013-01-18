# many-to-many relationship between App and MessageKey
class AppAllowedKey < ActiveRecord::Base
  attr_accessible :app_id, :message_key_id

  belongs_to :app
  belongs_to :message_key

  validates_uniqueness_of :message_key_id, scope: :app_id
end
