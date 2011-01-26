require 'rubygems'
require 'octopi'

class GitHubPlugin < Plugin

        include Octopi

        Config.register Config::ArrayValue.new('github.repomap',
                :default => [], :requires_restart => false,
                :desc => "A map of channels to GitHub repos. Format '#channel:github_user:github_repo' " +
                         "For example, '#vagrant:mitchellh:vagrant' " +
                         "Currently only one project can be monitored per channel.")

	def help(plugin, topic = "")
		case topic
			when '':
				"github: Queries GitHub information. " +
                                "Ask the bot for a commit or an issue using: " +
                                "bot: #11 - where #11 is the issue number. " +
                                "bot: commit:SHA - where SHA is the commit SHA."
		end
	end

	def listen(m)
		return if m.address?

                # Return unless we're addressed properly
		return unless m.kind_of?(PrivMessage) && m.public?

                refs = m.message.scan(/(?:^|\W)(\#\d+|commit:\w+)(?:$|\W)/).flatten

                return unless refs.length > 0

                refs.each do |ref|

                  answer = github_query(ref, m.target)

                  m.reply "#{m.sourcenick} #{ref} is #{answer}"
                end
        end

	private
        def github_query(ref, target)

          u, r = repo_channel(target)

          case
          when ref.match(/^\#(\d+)/)
            user = Octopi::User.find(u)
            repo = user.repository(r)
            issue = repo.issue($1)
            answer = "'#{issue.title}' which was created #{issue.created_at} and has a status of #{issue.state.capitalize}"
          when ref.match(/^commit\:(\w+)/)
            commit = Octopi::Commit.find(:user => u, :repo => r, :sha => $1)
            answer = "'#{commit.message}' and was created by #{commit.author['name']}"
          end

          return answer
        end

        def repo_channel(target)
               @bot.config['github.repomap'].each { |l|
                     l.scan(/^#{target}\:(.+)\:(.+)/) { |w|
                       return $1, $2
                     }
               }
        end
end

plugin = GitHubPlugin.new
