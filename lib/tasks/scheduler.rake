# write here rake tasks that will be called by scheduler

task :clear_delivered_messages => :environment do
  Rails.logger.info "clearing delivered messages"
  Message.clear_all_finished
end

task :deliver_messages => :environment do
  hydra = Typhoeus::Hydra.new
  Message.all.each do |msg|
    msg.queue_notification_requests(hydra)
  end
  hydra.run
end