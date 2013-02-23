# write here rake tasks that will be called by scheduler

task :clear_delivered_messages => ['admin:messages:clear']
task :deliver_messages => ['admin:messages:deliver']