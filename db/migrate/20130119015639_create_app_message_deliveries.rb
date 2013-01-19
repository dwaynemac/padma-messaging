class CreateAppMessageDeliveries < ActiveRecord::Migration
  def change
    create_table :app_message_deliveries do |t|
      t.integer :app_id
      t.integer :message_id
      t.boolean :delivered
    end
  end
end
