#
# adapters:
#
#   * Slack
#
#     example:
#
#       set :notify_adapter, :Slack
#
set :notify_adapter, -> { nil }

#
# default options:
#
#   * Slack:
#
#       team **required**
#
#       token **required**
#
#      example:
#
#        set :notify_default_options, team: 'my-team', token: 'token'
#
set :notify_default_options, -> { {} }

#
# subscribers
#
#    * Slack:
#
#      subscribers could be a user, or a channel
#
#      example:
#
#        set :subscribers, -> { ['@scorix', '#deploy'] }
#
set :subscribers, -> { [] }

namespace :notify do

  def find_adapter
    adapter = fetch(:notify_adapter, nil)

    if adapter
      adapter = Capistrano::Notifications::Adapter.const_get(adapter.to_sym).setup(fetch(:notify_default_options))

      begin
        yield adapter
      rescue => e
        warn e.message
      end
    end
  end

  task :starting do
    find_adapter do |adapter|
      adapter.notify(fetch(:subscribers), "@#{local_user} is deploying branch #{fetch(:branch)}")
    end
  end

  task :finishing do
    find_adapter do |adapter|
      adapter.notify(fetch(:subscribers), t(:revision_log_message,
                                            branch: fetch(:branch),
                                            user: "@#{local_user}",
                                            sha: fetch(:current_revision),
                                            release: fetch(:release_timestamp)))
    end
  end

  task :log_revision do
    on primary(:app) do
      previous_revision = nil

      within releases_path do
        previous_revision = capture(:grep, "deployed #{revision_log} | tail -n 1 | cut -f1 -d')' | cut -f4 -d' '")
      end

      within repo_path do
        git_log = capture(:git, "log --oneline --no-color #{fetch(:branch)} #{previous_revision}..#{fetch(:current_revision)} | sed 's/^M$//'")
        set(:git_log, git_log)
      end
    end
  end

end

before 'deploy:log_revision', 'notify:log_revision'
before 'deploy:starting', 'notify:starting'

after 'deploy:finishing', 'notify:finishing'
