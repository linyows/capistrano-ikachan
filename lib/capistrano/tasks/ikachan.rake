require 'string-irc'
require 'digest/md5'

namespace :ikachan do
  start = Time.now
  elapsed_time = -> { sprintf('%.2f', Time.now - start) }

  set :ikachan_channel, 'ikachan'
  set :ikachan_server, 'http://ikachan.example.com'
  set :ikachan_message_type, :notice

  set :ikachan_username, -> {
    username = `git config --get user.name`.strip
    username = `whoami`.strip unless username
    username
  }

  set :ikachan_start_icon, -> { StringIrc.new('✔').yellow }
  set :ikachan_failure_icon, -> { StringIrc.new('✘').red }
  set :ikachan_success_icon, -> { StringIrc.new('✔').light_green }

  set :ikachan_stage, -> {
    stage = "#{fetch(:stage)}"
    color = case stage
      when 'production' then :rainbow
      when 'staging' then :aqua
      when 'sandbox' then :pink
      when 'development' then :purple
      else :light_blue
      end
    StringIrc.new(stage).send(color)
  }

  set :ikachan_appname, -> {
    app = fetch(:application)

    magic_number = Digest::MD5.hexdigest(app).
      gsub(/[^0-9]/, '').split('').last.to_i

    colors = StringIrc::COLOR_TABLE.select { |k,v|
      2 < k && k < 13 && k != 4 && k != 13
    }.map { |k,v| v.last }
    color = colors[magic_number].to_sym

    StringIrc.new(app).send(color)
  }

  set :ikachan_start_message, -> {
    <<-MSG.gsub(/\s+/, ' ')
      #{fetch(:ikachan_appname)}: #{fetch(:ikachan_start_icon)} started deploying
      to #{fetch(:ikachan_stage)} by #{fetch(:ikachan_username)}
      (branch #{fetch(:branch)})
    MSG
  }

  set :ikachan_failure_message, -> {
    <<-MSG.gsub(/\s+/, ' ')
      #{fetch(:ikachan_appname)}: #{fetch(:ikachan_failure_icon)} failed deploying
      to #{fetch(:ikachan_stage)} by #{fetch(:ikachan_username)}
      (branch #{fetch(:branch)} at #{fetch(:current_revision)} / #{elapsed_time.call} sec)
    MSG
  }

  set :ikachan_success_message, -> {
    task = fetch(:deploying) ? 'deployment' : 'rollback'
    <<-MSG.gsub(/\s+/, ' ')
      #{fetch(:ikachan_appname)}: #{fetch(:ikachan_success_icon)} successful #{task}
      to #{fetch(:ikachan_stage)} by #{fetch(:ikachan_username)}
      (branch #{fetch(:branch)} at #{fetch(:current_revision)} / #{elapsed_time.call} sec)
    MSG
  }

  def notify_with_ikachan(message)
    channel = fetch(:ikachan_channel)
    host = fetch(:ikachan_server)
    type = fetch(:ikachan_message_type)

    run_locally do
      execute :curl, '-s',
        "-F channel=\##{channel}",
        "#{host}/join"
      execute :curl, '-s',
        "-F channel=\##{channel}",
        "-F message=\"#{message}\"",
        "#{host}/#{type}"
    end
  end

  desc 'Notify message to IRC with Ikachan'
  task :notify, :message do |t, args|
    notify_with_ikachan args[:message]
  end

  desc 'Notify start to IRC with Ikachan'
  task :notify_start do
    notify_with_ikachan fetch(:ikachan_start_message)
  end

  desc 'Notify rollback to IRC with Ikachan'
  task :notify_rollback do
    message = fetch(:deploying) ? :ikachan_failure_message : :ikachan_success_message
    notify_with_ikachan fetch(message)
  end

  desc 'Notify deployment to IRC with Ikachan'
  task :notify_deployment do
    notify_with_ikachan fetch(:ikachan_success_message)
  end
end
