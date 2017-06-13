class AppMessageDeliveriesAttempts < ActiveRecord::Migration
  def change
    add_column :app_message_deliveries, :attempts, :integer
  end
end
