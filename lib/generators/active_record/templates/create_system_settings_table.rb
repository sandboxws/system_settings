class CreateSystemSettingsTable < ActiveRecord::Migration<%= Rails::VERSION::MAJOR >= 5 ? "[#{Rails.version.to_f}]" : "" %>
  def self.up
    create_table :system_settings, :force => true do |t|
      t.string :key
      t.string :value
      t.string :data_type
      t.boolean :cache, default: false
      t.integer :cache_duration, default: 0
      t.datetime :cached_at

      t.timestamps
    end
    add_index :system_settings, :key
  end

  def self.down
    drop_table :system_settings
  end
end
