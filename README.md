# Capistrano::Notifications

Send notifications around deploy to teammates(subscribers).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-notifications', github: 'scorix/capistrano-notifications'
```

And then execute:

    $ bundle

## Usage

### Slack

in deploy.rb

```ruby
# deploy.rb
set :notify_default_options, team: 'my-team', token: 'token'
set :notify_adapter, :Slack
set :subscribers, %w(@scorix #deploy)
```

in Capfile

```ruby
# Capfile

require 'capistrano/notifications'
```

## Contributing

1. Fork it ( https://github.com/scorix/capistrano-notifications/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

