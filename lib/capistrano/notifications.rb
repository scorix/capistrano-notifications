require 'faraday'
require 'json'

module Capistrano
  module Notifications
    autoload :Adapter, 'capistrano/notifications/adapter'
  end
end

load File.expand_path('../tasks/notifications.rake', __FILE__)