module SystemSettings
  module Generators
    class SystemSettingsGenerator < Rails::Generators::Base
      hook_for :orm
      source_root File.expand_path('../templates', __FILE__)
      argument :orm, type: :string, default: 'active_record'

      def copy_config_file
        template 'system_settings.rb', 'config/initializers/system_settings.rb'
      end
    end
  end
end
