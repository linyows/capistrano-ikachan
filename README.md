Capistrano::Ikachan
===================

Irc notification tasks with Ikachan for Capistrano v3.

[![Gem version](https://img.shields.io/gem/v/capistrano-ikachan.svg?style=flat-square)][gem]
[gem]: https://rubygems.org/gems/capistrano-ikachan

Installation
------------

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-ikachan'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install capistrano-ikachan
```

Usage
-----

Capfile:

```ruby
require 'capistrano/ikachan'
```

config.rb:

```ruby
set :ikachan_channel, 'ikachan'
set :ikachan_server, 'http://ikachan.example.com'

after 'deploy:started', 'ikachan:notify_start'
after 'deploy:finishing', 'ikachan:notify_deployment'
after 'deploy:finishing_rollback', 'ikachan:notify_rollback'
```

Contributing
------------

1. Fork it ( http://github.com/linyows/capistrano-ikachan/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Authors
-------

- [linyows](https://github.com/linyows)

License
-------

The MIT License (MIT)
