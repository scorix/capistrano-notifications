module Capistrano
  module Notifications
    module Adapter
      autoload :Base, 'capistrano/notifications/adapter/base'
      autoload :Slack, 'capistrano/notifications/adapter/slack'
    end
  end
end