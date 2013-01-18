class CreateNotifyMes < ActiveRecord::Migration
  def change
    create_table :notify_mes do |t|
      t.integer :message_key_id
      t.string :url
      t.integer :app_id

      t.timestamps
    end
  end
end
