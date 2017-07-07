require 'system_settings/load'

module SystemSettings
  # Define default ORM
  mattr_accessor :orm
  @@orm = :active_record

  # Load configuration from initializer
  def self.setup
    yield self
  end

  # Easy access to system settings, similar to calling SystemSettings.get key, default_value
  # Example:
  # SystemSettings.set 'foo', 'bar'
  # SystemSettings.get('foo') == SystemSettings.foo
  def self.method_missing(name, *args, &block)
    self.get name.to_s, *args
  end

  def self.get_object(key)
    SystemSetting.where(key: key.underscore).first
  end

  def self.get(key, default = nil)
    system_settings = Rails.cache.read cache_key(key)
    if !system_settings.nil?
      system_settings
    else
      system_settings = self.get_object(key)
      if system_settings
        if system_settings.cache
          system_settings.cached_at = Time.now
          system_settings.save
          Rails.cache.write cache_key(key), value, expires_in: system_settings.cache_duration
        end
        system_settings.value
      else
        default
      end
    end
  end

  def self.set(key, value, cache = false, data_type = 'string')
    system_settings = self.get_object(key)
    if system_settings.nil?
      system_settings = SystemSetting.new
    end

    key = key.underscore
    cache_duration = resolve_cache_duration cache
    system_settings.key = key
    system_settings.value = value
    system_settings.data_type = data_type
    if cache_duration
      system_settings.cache = true
      system_settings.cached_at = Time.now
      system_settings.cache_duration = cache_duration
    end
    if system_settings.save
      if cache_duration
        Rails.cache.write cache_key(key), value, expires_in: cache_duration
      else
        true
      end
    else
      false
    end
  end

  def self.del(key)
    key = key.underscore
    system_settings = Rails.cache.write cache_key(key), nil
    system_settings = SystemSetting.where(key: key).first
    if system_settings
      system_settings.destroy
    else
      true
    end
  end

  def self.cache_key(key)
    "sandboxws/system_settings/#{key.underscore}"
  end

  def self.resolve_cache_duration(cache)
    cache_duration = false
    if cache
      if cache.instance_of?(ActiveSupport::Duration)
        cache_duration = cache
      else
        cache_duration = 30.days
      end
    end

    cache_duration
  end
end
