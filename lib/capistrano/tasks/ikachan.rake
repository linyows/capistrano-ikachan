require 'string-irc'

namespace :ikachan do
  start = Time.now

  set :ikachan_channel, 'ikachan'
  set :ikachan_server, 'http://ikachan.example.com'
  set :ikachan_message_type, 'notice'

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

  set :ikachan_start_message, -> {
    state = StringIrc.new('started').orange.bold.to_s
    "#{fetch(:username)} #{state} deployment to #{fetch(:destination)} of #{fetch(:application)} from #{fetch(:branch)} by cap"
  }

  set :ikachan_end_message, -> {
    elapse_time = "(#{sprintf('%.2f', Time.now - start)} sec)"
    state = StringIrc.new('finished').green.bold.to_s
    "#{fetch(:username)} #{state} deployment to #{fetch(:destination)} by cap #{elapse_time}"
  }

  def notify_to_ikachan(message)
    channel = fetch(:ikachan_channel)
    host = fetch(:ikachan_server)
    type = fetch(:ikachan_message_type)
    `curl -s -F channel=\##{channel} #{host}/join`
    `curl -s -F channel=\##{channel} -F message="#{message}" #{host}/#{type}`
  end

  task :notify_start do
    notify_to_ikachan fetch(:ikachan_start_message)
  end

  task :notify_end do
    notify_to_ikachan fetch(:ikachan_end_message)
  end
end
