namespace :admin do

  namespace :apps do
    desc 'lists registered apps'
    task :list => :environment do
      App.all.each do |app|
        puts "===== #{app.name} (#{app.app_key}) ====="
        puts "Can post: #{app.allowed_message_keys.map(&:name).join(',')}"
        puts "Receives: #{app.notify_mes.map{|n| "#{n.key_name}:#{n.secret_key}@#{n.url}"}.join(', ')}"
        puts ""
      end
    end
  end

  namespace :messages do
    desc 'clears all delivered messages from DB'
    task :clear => :environment do
      Rails.logger.info "clearing delivered messages"
      Message.clear_all_finished
      Message.destroy_old
    end

    desc 'delivers all pending notifications'
    task :deliver => :environment do
      hydra = Typhoeus::Hydra.new
      Message.all.each do |msg|
        msg.queue_notification_requests(hydra)
      end
      hydra.run
    end
  end
end
