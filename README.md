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

Add this line to your application's Gemfile. Anywhere will be fine, but it is
best to put in a non-standard group to prevent it from being loaded into memory
automatically by Rails:

    group :deployment do
      gem 'mail_car'
    end

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mail_car

### With Capistrano deployment tool

In config/deploy.rb:

    require 'mail_car/capistrano'

    set :mail_car_config, {
      # MailCar config options.
    }

If using multistage then different config options can be used for different
stages (obviously).

## Configuration

The MailCar config is a hash with the following options:

    {
      mailer: {
        # Normal ActionMailer class config, e.g:
        delivery_method: :smtp,
        smtp_settings: {
          address: "smtp.gmail.com",
          port: 587,
          user_name: "username@gmail.com",
          password: "password",
          authentication: :plain,
        },
      },

      # Or just use sendmail for sending:
      # mailer: {
      #   delivery_method: :sendmail,
      # },

      from: %(your.email@example.com),
      recipients: %w(your.email@example.com another.email@example.com),
      subject: %([DEPLOY] MyApp has been successfully deployed),
    }

When using sendmail, `:from` can be omitted to let sendmail handle it.
`:subject` is not required.

When using git, a `git_format` option can be used to control the output of the shortlogs:

      # This is the default:
      git_format: %(* %ad %s%+b)

### Source Control Management

The scm type should be automatically picked up via the deployment tool config,
so no extra configuration necessary. (As of writing this is quite moot since it
only supports git anyway, but it should be easy to support other scm types in
the future.)

## Usage

When configured properly a mail will be sent out automatically after a
successful deployment.

To manually launch a mail (for e.g. testing):

    cap deploy:send_notification

This is highly recommended, because if there is something wrong with the
configuration (or a bug is triggered) then the entire deployment will be
aborted and rolled back (by nature of capistrano).

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
