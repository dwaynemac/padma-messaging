class AddPostKey < ActiveRecord::Migration
  def change
    add_column :notify_mes, :secret_key, :text
  end
end
