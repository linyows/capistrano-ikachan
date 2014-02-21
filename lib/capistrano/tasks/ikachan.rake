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

  set :start_icon, -> { StringIrc.new('✔').orange.to_s }
  set :failure_icon, -> { StringIrc.new('✘').red.to_s }
  set :success_icon, -> { StringIrc.new('✔').light_green.to_s }

  set :destination, -> {
    stage = "#{fetch(:stage)}"
    color = case stage
      when 'production' then :rainbow
      when 'staging' then :light_blue
      when 'sandbox' then :yellow
      when 'development' then :purple
      else :grey
      end
    StringIrc.new(stage).send(color)
  }

  set :ikachan_start_message, -> {
    "#{fetch(:application)}: #{fetch(:start_icon)} started deploying to #{fetch(:destination)} of #{fetch(:branch)} by #{fetch(:username)}"
  }

  set :ikachan_failure_message, -> {
    elapse_time = "(#{sprintf('%.2f', Time.now - start)} sec)"
    "#{fetch(:application)}: #{fetch(:failure_icon)} failed deploying to #{fetch(:destination)} of #{fetch(:branch)} by #{fetch(:username)} #{elapse_time}"
  }

  set :ikachan_success_message, -> {
    elapse_time = "(#{sprintf('%.2f', Time.now - start)} sec)"
    "#{fetch(:application)}: #{fetch(:success_icon)} successful deployment to #{fetch(:destination)} of #{fetch(:branch)} by #{fetch(:username)} #{elapse_time}"
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

  task :notify_failure do
    notify_to_ikachan fetch(:ikachan_failure_message)
  end

  task :notify_success do
    notify_to_ikachan fetch(:ikachan_success_message)
  end
end
