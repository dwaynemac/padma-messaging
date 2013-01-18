class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :app_id
      t.integer :message_key_id
      t.text :data

      t.timestamps
    end
  end
end
