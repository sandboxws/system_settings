class SystemSetting < ActiveRecord::Base
  self.table_name = 'system_settings'

  def to_s
    case data_type
    when 'string'
      value
    else
      # TODO: handle different data types
      value
    end
  end
end
