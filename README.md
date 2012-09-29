# BriefMail

BriefMail is a deployment notification mailer designed for Rails 3. The
deployment mail it sends out contains a compact log and diff stat summary from
the source control management which also includes summaries for each git
submodule.

Currently only git source control management and capistrano deployment tool is
supported, but an abstraction layer (inspired by ActiveRecord) exists to
hopefully allow for easy integration with other tools.

## Example output

Just to give an idea on what the mails look like. Both the git format used as
well as the template it self can be easily customized.

    Test Application has been deployed to test @ 2012-09-29 18:57:30 +0200.

    ## Paths

    Previous: /tmp/prev @ dd1afc4
    Current:  /tmp/current @ d461201

    ## Commits since last deploy (most recent at bottom)

    * 2012-09-28 .gitignore: Clean up.
    * 2012-09-28 bundle gem + initial code.
    * 2012-09-29 lib/mail_car/capistrano: Move integration here. Clean up README.
    * 2012-09-29 config/adapters/abstract_adapter: Return user config has via from_user.
    Instead of duplicating the hash parsing code for each config adapter we
    might as well do it in the abstract adapter.

    * 2012-09-29 scm/adapters/git: Support git_format option.
    * 2012-09-29 mailcar.gemspec: Require actionmailer.
    * 2012-09-29 README: Clarification.
    * 2012-09-29 scm_adapters: Bugfix for git_format.
    * 2012-09-29 mailer: Proxy all config options directly to ActionMailer.
    Might as well.

    * 2012-09-29 README: File delivery method.
    * 2012-09-29 Rename shortlog to log, since it's not really short (by default).
    * 2012-09-29 Rename to BriefMail.
    Turns out MailCar was taken.

    * 2012-09-29 Rakefile: Setup test environment with MiniTest.
    * 2012-09-29 config_adapters/abstract_adapter_test: Add.
    * 2012-09-29 config/adapters/capistrano_test: Add.
    * 2012-09-29 scm_adapters/abstract_adapter_test: Add.
    * 2012-09-29 scm_adapters/abstract_adapter: Require config upon initialization.
    * 2012-09-29 scm_adapters/git_test: Add.
    * 2012-09-29 mailer: Require one or more recipients.
    * 2012-09-29 mailer_test: Add.
    * 2012-09-29 README: Minor adjustments.
    * 2012-09-29 README: Fix typo.
    * 2012-09-29 views/deploy_notification: Fix typo.
    * 2012-09-29 brief_mail.gemspec: Make minitest development dependency.
    * 2012-09-29 mailer: Add template option.
    * 2012-09-29 .gitignore: Add pkg directory.
    * 2012-09-29 HISTORY: Updated.
    * 2012-09-29 BriefMail v0.0.2
    * 2012-09-29 mailer_test: Update.
    * 2012-09-29 BriefMail v0.0.3

    ## Files changed since last deploy

     .gitignore                                         |   23 +--
     Gemfile                                            |    4 +
     HISTORY.md                                         |   14 ++
     LICENSE.txt                                        |   22 +++
     README.md                                          |  164 +++++++++++++++++++-
     Rakefile                                           |   11 ++
     brief_mail.gemspec                                 |   24 +++
     lib/brief_mail.rb                                  |    5 +
     lib/brief_mail/capistrano.rb                       |   14 ++
     lib/brief_mail/config_adapters.rb                  |   16 ++
     lib/brief_mail/config_adapters/abstract_adapter.rb |   44 ++++++
     lib/brief_mail/config_adapters/capistrano.rb       |   43 +++++
     lib/brief_mail/mailer.rb                           |   42 +++++
     lib/brief_mail/scm_adapters.rb                     |   17 ++
     lib/brief_mail/scm_adapters/abstract_adapter.rb    |   35 +++++
     lib/brief_mail/scm_adapters/git.rb                 |   86 ++++++++++
     lib/brief_mail/version.rb                          |    3 +
     lib/brief_mail/views/deploy_notification.txt.erb   |   29 ++++
     .../config_adapters/abstract_adapter_test.rb       |   39 +++++
     test/brief_mail/config_adapters/capistrano_test.rb |   47 ++++++
     test/brief_mail/mailer_test.rb                     |   48 ++++++
     test/scm_adapters/abstract_adapter_test.rb         |   19 +++
     test/scm_adapters/git_test.rb                      |   75 +++++++++
     test/test_helper.rb                                |    2 +
     24 files changed, 807 insertions(+), 19 deletions(-)

    ---
    This is an automatically generated deployment message from BriefMail.

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

```ruby
group :deployment do
  gem 'brief_mail'
end
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install brief_mail

### With Capistrano deployment tool

In config/deploy.rb:

```ruby
require 'brief_mail/capistrano'

set :brief_mail_config, {
  # BriefMail config options.
}
```

If using multistage then different config options can be used for different
stages (obviously).

## Configuration

The BriefMail config is a hash with the following options:

```ruby
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
```

When using sendmail, `:from` can be omitted to let sendmail handle it.
`:subject` is not required.

Please see http://api.rubyonrails.org/classes/ActionMailer/Base.html for
ActionMailer config options.

When using git, a `git_format` option can be used to control the output of the
logs:

```ruby
# This is the default:
git_format: %(* %ad %s%+b)
```

A different/custom template can be used by specifying in the config:

```ruby
template: 'app/views/some_template.txt' # trailing .erb is not needed.
```

Some variables with useful data and methods are available in the template,
please read the source for the API:

* `@config`: [`lib/brief_mail/config_adapters/abstract_adapter.rb`](https://github.com/sce/brief_mail/blob/master/lib/brief_mail/config_adapters/abstract_adapter.rb)
* `@scm`: [`lib/brief_mail/scm_adapters/abstract_adapter.rb`](https://github.com/sce/brief_mail/blob/master/lib/brief_mail/scm_adapters/abstract_adapter.rb)

### Source Control Management

The scm type should be automatically picked up via the deployment tool config,
so no extra configuration necessary. (As of writing this is quite moot since it
only supports git anyway, but it should be easy to support other scm types in
the future.)

## Usage

When configured properly a mail will be sent out automatically after a
successful deployment.

For checking how the deploy mail will look (without configuring the mailer)
then the ActionMailer file delivery option can be used:

```ruby
{
  mailer: {
    delivery_method: :file,
    file_settings: {
      location: File.dirname(__FILE__),
    },

  recipients: %(brief_mail.output),
}
```

This will write the mail to `brief_mail.output` in the same directory as the
config file instead of sending it as a mail.

### Capistrano

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

## Credits

This gem was inspired by the lightweight mailer posted at
https://gist.github.com/955917, written by rtekie and John Lynch
(johnthethird), which is a Rails 3 port of the email notifier posted at
http://www.codeography.com/2010/03/24/simple-capistrano-email-notifier-for-rails.html
which is written by Christopher Sexton.

The AbstractionAdapters are inspired by ActiveRecord.

BriefMail is written by S. Christoffer Eliesen (http://github.com/sce).

## License

See LICENSE.txt.
