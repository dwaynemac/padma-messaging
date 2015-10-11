require 'set_by_name'
class Message < ActiveRecord::Base

  include SetByName

  attr_accessible :data, :key_name, :app_name

  belongs_to :app
  validates_presence_of :app_id

  belongs_to :message_key
  validates_presence_of :message_key_id

  has_many :registered_apps, through: :message_key

  has_many :app_message_deliveries, dependent: :destroy

  ##
  # Destroys all messages that have been fully delivered
  #
  def self.clear_all_finished
    Message.all.each { |msg| msg.destroy if msg.finished_delivery? }
  end

  OLD_TIME = 1.week
  ##
  # Destroys all messages that have been created more than OLD_TIME ago
  #
  def self.destroy_old
    Message.where("created_at < ?", OLD_TIME.ago).destroy_all
  end

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
  # Checks if notification has been sent and received to all
  # subscribed applications
  #
  # @return [Boolean]
  def finished_delivery?
    delivered_ids = app_message_deliveries.select { |d| d.delivered? }.map(&:app_id)
    registered_ids = message_key.notify_mes.map(&:app_id)
    delivered_ids.sort == registered_ids.sort
  end

  ##
  # It makes a POST request to subcribed apps URL
  # @return [Boolean]
  def notify_subscribed_apps
    return true if finished_delivery?
    hydra = Typhoeus::Hydra.new
    queue_notification_requests(hydra)
    hydra.run
    return finished_delivery?
  end

  ##
  # Queues POST requests in given hydra
  # @return [Typhoues::Hydra]
  def queue_notification_requests(hydra)
    message_key.notify_mes.each do |nm|
      unless delivered_to?(nm.app)

        request_body = {
            key_name: message_key.name,
            data: data
        }

        if nm.secret_key
          request_body.merge!({secret_key: nm.secret_key})
        end

        req = Typhoeus::Request.new(
            nm.url,
            body: request_body
        )

        req.on_complete do |response|
          if response.success?
            Rails.logger.info "delivered notifications for message#id:#{self.id}"
            mark_delivered_to(nm.app)
          else
            Rails.logger.info "notification #{nm.app.name} for message#id:#{self.id} failed."
          end
        end
        hydra.queue(req)
        Rails.logger.info "queued notifications for message#id:#{self.id}"
      end
    end
    hydra
  end
end
