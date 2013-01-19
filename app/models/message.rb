require 'set_by_name'
class Message < ActiveRecord::Base

  include SetByName

  attr_accessible :data, :key_name, :app_name

  belongs_to :app
  validates_presence_of :app_id

  belongs_to :message_key
  validates_presence_of :message_key_id

  has_many :app_message_deliveries, dependent: :destroy

  ##
  # Checks if this message has been delivered to given app
  # @param [App] app
  # @return [Boolean]
  def delivered_to?(app)
    delivery = app_message_deliveries.where(app_id: app.id).last
    delivery && delivery.delivered?
  end

  ##
  # Sets this message as delivered to given app
  # @param [App] app
  # @return [Boolean]
  def mark_delivered_to(app)
    delivery = app_message_deliveries.where(app_id: app.id).last
    if delivery.nil?
      delivery = app_message_deliveries.new(app_id: app.id)
    end
    delivery.delivered=(true)
    delivery.save
  end

  ##
  # Checks if notification has been sent and receieved to all
  # subscribed applications
  #
  # @return [Boolean]
  def finished_delivery?
    app_message_deliveries.select{|d|d.delivered?}.map(&:app_id).sort == message_key.registered_apps.map(:app_id).sort
  end

  ##
  # It makes a POST request to que URL
  # @return [Boolean]
  def notify_subscribed_apps
    return true if finished_delivery?
    hydra = Typhoeus::Hydra.new
    message_key.notify_mes.each do |nm|
      unless delivered_to?(nm.app)
        req = Typhoeus::Request.new(
            nm.url,
            body: {
                key_name: message_key.name,
                data: data
            }
        )
        req.on_complete do |response|
          if response.success?
            mark_delivered_to(nm.app)
          end
        end
        hydra.queue(req)
      end
      hydra.run
    end
    return finished_delivery?
  end
end
