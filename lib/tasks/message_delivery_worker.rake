namespace :messages_worker do
  desc 'Polls constantly for new messages and delivers them'
  task :run => :environment do
    puts "Starting MessagesWorker"
    begin
      loop do
        begin
          hydra = Typhoeus::Hydra.new
          puts "Polling for messages"
          messages = Message.all
          if messages.empty?
            puts '  no messages'
          else
            messages.each do |msg|
              puts "  managing message: #{msg.id}"
              msg.queue_notification_requests(hydra)
            end
          end
          hydra.run
          sleep 1.minute
        rescue StandardError => e
          puts "Exception in MessagesWorker: #{e.message}"
        end
      end
    rescue SignalException => e
      puts "Ending MessagesWorker with signal: #{e}"
    end
    puts "MessageWorker exits"
  end
end

