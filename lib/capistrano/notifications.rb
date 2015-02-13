require 'faraday'
require 'json'
require 'active_support/core_ext/string'
require 'active_support/core_ext/array'

module Capistrano
  module Notifications
    autoload :Adapter, 'capistrano/notifications/adapter'
  end
end

load File.expand_path('../tasks/notifications.rake', __FILE__)