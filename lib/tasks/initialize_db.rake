task :initialize_db => :environment do

  # create message keys
  %W(
    enrollment
    drop_out
    communication
  ).each do |name|
    MessageKey.create!(name: name) unless MessageKey.find_by_name(name)
  end
end