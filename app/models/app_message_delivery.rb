class AppMessageDelivery < ActiveRecord::Base
  attr_accessible :app_id, :delivered, :message_id

  belongs_to :app
  belongs_to :message

  validates_presence_of :app
  validates_presence_of :message
end
