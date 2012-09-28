# MailCar

MailCar is a deployment notification mailer designed for Rails 3. The
deployment mail it sends out contains a short log and diff stat summary from
the source control management which also includes summaries for each git
submodule.

Currently only git source control management and capistrano deployment tool is
supported, but an abstraction layer (inspired by ActiveRecord) exists to
hopefully allow for easy integration with other tools.

## Requirements

* Ruby 1.9.2+
* Rails 3
* Git
* Capistrano

Also, this gem has only been tested on Linux, so it will probably fail
miserably on other platforms.

## Installation

Add this line to your application's Gemfile:

    gem 'mail_car'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mail_car

### Source Control Management

The scm should be automatically picked up via the deployment tool config, so no
extra configuration necessary.

### With Capistrano deployment tool

In config/deploy.rb:

    require 'mail_car'

    set :mail_car_config, {
      mailer: {
        # Normal action_mailer config, e.g:
        address: "smtp.gmail.com",
        port: 587,
        user_name: "username@gmail.com",
        password: "password",
        authentication: :plain,
      },

      from: %(your.email@example.com),
      recipients: %w(your.email@example.com another.email@example.com),
      subject: %([DEPLOY] MyApp has been successfully deployed),
    }

    after :deploy, "deploy:send_notification"

Or just use sendmail for sending:

    set :mail_car_config, {
      mailer_config: :sendmail,

      # ...
    }

When using sendmail, :from can be omitted to let sendmail handle it.

:subject is not required. If using multistage then different config options can
be used for different stages (obviously).

To manually launch a mail (for e.g. testing):

    cap deploy:send_notification

## Usage

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright Sten Christoffer Eliesen 2012.

This gem was inspired by the lightweight mailer posted at
https://gist.github.com/955917, written by rtekie and John Lynch
(johnthethird), which is a Rails 3 port of the email notifier posted at
http://www.codeography.com/2010/03/24/simple-capistrano-email-notifier-for-rails.html
which is written by Christopher Sexton.

The AbstractionAdapters are inspired by ActiveRecord.

## License

See LICENSE.txt.
