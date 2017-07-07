module SystemSettings
  class Engine < ::Rails::Engine
    attr_accessor :orm

    initializer 'system_settings.model' do |app|
      @orm = SystemSettings.orm
      include_orm
    end

    # initializer 'system_settings.controller' do
    #   require "system_settings/controllers/mongoid/system_settings_controller.rb" if orm == :mongoid.to_s

    #   ActiveSupport.on_load(:action_controller) do
    #     include ImpressionistController::InstanceMethods
    #     extend ImpressionistController::ClassMethods
    #   end
    # end

    private

    def include_orm
      require "system_settings/models/#{orm}/system_setting.rb"
    end
  end
end
