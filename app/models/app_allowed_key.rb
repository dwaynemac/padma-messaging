require 'set_by_name'
# many-to-many relationship between App and MessageKey
class AppAllowedKey < ActiveRecord::Base
  include SetByName

  attr_accessible :app_name, :key_name

  belongs_to :app
  belongs_to :message_key

  validates_uniqueness_of :message_key_id, scope: :app_id
end
