require 'set_by_name'
class Message < ActiveRecord::Base

  include SetByName

  attr_accessible :data, :key_name, :app_name

  belongs_to :app
  validates_presence_of :app_id

  belongs_to :message_key
  validates_presence_of :message_key_id

end
