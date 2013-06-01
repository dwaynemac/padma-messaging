namespace :messages_worker do
  desc 'Polls constantly for new messages and delivers them'
  task :run => :environment do
    puts "Starting MessagesWorker"
    begin
      loop do
        begin
          hydra = Typhoeus::Hydra.new
          Message.all.each do |msg|
            Rails.logger.info "Managing message: #{msg.id}"
            msg.queue_notification_requests(hydra)
          end
          hydra.run
          sleep 1.minute
        rescue StandardError => e
          Rails.logger.warn("Exception in MessagesWorker: #{e.message}")
        end
      end
    rescue SignalException => e
      puts "Ending MessagesWorker. (#{e})"
    end
  end
end

