class AppMessageDelivery < ActiveRecord::Base
  attr_accessible :app_id, :delivered, :message_id, :attempts

  belongs_to :app
  belongs_to :message

  validates_presence_of :app
  validates_presence_of :message

  validates_uniqueness_of :app_id, scope: :message_id
  
  ATTEMPTS_TOLERANCE = 10
  # this delivery should be aborted
  def abort?
    !delivered && !attempts.nil? && (attempts > ATTEMPTS_TOLERANCE)
  end
  
  def finished?
    delivered || abort?
  end
end
