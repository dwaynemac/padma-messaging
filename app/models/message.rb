class Message < ActiveRecord::Base
  attr_accessible :data, :key_name, :app_name

  belongs_to :app
  validates_presence_of :app_id

  belongs_to :message_key
  validates_presence_of :message_key_id

  def app_name=(name)
    self.app_id= App.find_by_name(name).try(:id)
  end

  # @return [String] name of app that issued this message
  def app_name
    self.app.try(:name)
  end

  # @return [String]
  def key_name
    self.message_key.try(:name)
  end

  def key_name=(name)
    self.message_key_id= MessageKey.find_by_name(name).try(:id)
  end

end
