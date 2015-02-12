module Capistrano
  module Notifications
    module Adapter
      class Base

        def self.setup(*args)
          options = args.last.is_a?(Hash) ? args.last : {}

          instance = self.new
          options.each { |k, v| instance.instance_variable_set("@#{k}", v) }
          instance
        end

        def notify(members = [], message = '')
          members.each { |member| send_notification(member, message) }
        end

        protected

        def send_notification(_member, _message)
          raise NoMethodError, 'send_notification is not defined.'
        end

      end
    end
  end
end