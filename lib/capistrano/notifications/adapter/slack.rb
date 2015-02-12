module Capistrano
  module Notifications
    module Adapter
      class Slack < Base

        attr_reader :team, :token

        protected
        def send_notification(_member, _message)
          connection = Faraday.new(url: "https://#{team}.slack.com") do |faraday|
            faraday.request :url_encoded
            faraday.adapter Faraday.default_adapter
          end
          connection.post do |req|
            req.url '/services/hooks/incoming-webhook'
            req.headers['User-Agent'] = "Capistrano Notification #{Capistrano::Notifications::VERSION}"
            req.body = {
                token: token,
                payload: {
                    channel: "#{_member}",
                    username: "#{fetch(:application)} #{fetch(:env)}",
                    text: _message,
                    icon_emoji: ':grin:',
                    mrkdwn: true
                }.to_json
            }
          end
        end

      end
    end
  end
end