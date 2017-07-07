SystemSettings.setup do |config|
  # Define ORM. Only :active_record is supported now
  config.orm = <%= ":#{options.orm}" %>
end
