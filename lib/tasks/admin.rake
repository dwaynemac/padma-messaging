namespace :admin do

  task :list_apps => :environment do
    App.all.each do |app|
      puts "===== #{app.name} (#{app.app_key}) ====="
      puts "Can post: #{app.allowed_message_keys.map(&:name).join(',')}"
      puts "Receives: #{app.notify_mes.map{|n| "#{n.key_name}:#{n.secret_key}@#{n.url}"}.join(', ')}"
      puts ""
    end
  end
end