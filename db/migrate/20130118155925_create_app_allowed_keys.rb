class CreateAppAllowedKeys < ActiveRecord::Migration
  def change
    create_table :app_allowed_keys do |t|
      t.integer :app_id
      t.integer :message_key_id

      t.timestamps
    end
  end
end
