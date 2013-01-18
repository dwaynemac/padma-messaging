class CreateMessageKeys < ActiveRecord::Migration
  def change
    create_table :message_keys do |t|
      t.string :name
    end
  end
end
