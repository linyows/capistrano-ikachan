Capistrano::Ikachan
===================

This is capistrano task for  capistrano 3.

Installation
------------

Add this line to your application's Gemfile:

    gem 'capistrano-ikachan'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-ikachan

Usage
-----

Capfile:

```ruby
require 'capistrano/ikachan'
```

config.rb:

```ruby
set irc_channel, 'ikachan'
set irc_server, 'http://chat.freenode.net'

before 'deploy:starting', 'irc:notify_start'
after 'deploy:finished', 'irc:notify_end'
```

Contributing
------------

1. Fork it ( http://github.com/<my-github-username>/capistrano-ikachan/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
