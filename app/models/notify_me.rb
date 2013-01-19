require 'set_by_name'
class NotifyMe < ActiveRecord::Base

  include SetByName

  attr_accessible :url, :key_name

  validates_presence_of :message_key_id
  validates_presence_of :app_id
  validates_presence_of :url

  belongs_to :app
  belongs_to :message_key

  validates_format_of :url, with: /^https:\/\//

  def as_json(opts={})
    super(except: [:app_id, :message_key_id], methods: [:key_name, :app_name])
  end

end
