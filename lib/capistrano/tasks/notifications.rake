#
#   examples:
#
#     * Slack
#
#       set :notify, -> {
#         {
#             to: %w(@scorix #deploy),
#             via: :slack,
#             options: {team: 'my-team', token: 'token'}
#         }
#       }
#
set :notify, -> { {} }

namespace :notify do

  def notify
    fetch(:notify) { {} }
  end

  def find_adapter
    adapter = notify[:via]

    if adapter
      adapter = Capistrano::Notifications::Adapter.const_get(adapter.to_s.classify.to_sym).setup(notify[:options])

      begin
        yield adapter
      rescue => e
        warn e.message
      end
    end
  end

  task :starting do
    find_adapter do |adapter|
      adapter.notify(notify[:to], "#{local_user} is deploying the `#{fetch(:branch)}` branch...")
    end
  end

  task :finishing do
    find_adapter do |adapter|
      adapter.notify(notify[:to], revision_log)
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
