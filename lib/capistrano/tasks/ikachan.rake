require 'string-irc'

namespace :irc do
  start = Time.now

  set :irc_channel, 'ikachan'
  set :irc_server, 'http://chat.freenode.net'
  set :irc_message_type, 'notice'

  set :username, -> {
    username = `git config --get user.name`.strip
    username = `whoami`.strip unless username
    username
  }

  set :destination, -> {
    stage = "#{fetch(:stage)}"
    color = case stage
            when 'production' then :rainbow
            when 'staging' then :light_blue
            else :grey
            end
    StringIrc.new(stage).send(color)
  }

  set :irc_start_message, -> {
    state = StringIrc.new('started').orange.bold.to_s
    "#{fetch(:username)} #{state} deployment to #{fetch(:destination)} of #{fetch(:application)} from #{fetch(:branch)} by cap"
  }

  set :irc_end_message, -> {
    elapse_time = "(#{sprintf('%.2f', Time.now - start)} sec)"
    state = StringIrc.new('finished').green.bold.to_s
    "#{fetch(:username)} #{state} deployment to #{fetch(:destination)} by cap #{elapse_time}"
  }

  def notify_to_irc(message)
    channel = fetch(:irc_channel)
    host = fetch(:irc_server)
    type = fetch(:irc_message_type)
    `curl -s -F channel=\##{channel} #{host}/join`
    `curl -s -F channel=\##{channel} -F message="#{message}" #{host}/#{type}`
  end

  task :notify_start do
    notify_to_irc fetch(:irc_start_message)
  end

  task :notify_end do
    notify_to_irc fetch(:irc_end_message)
  end
end
