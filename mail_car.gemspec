# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mail_car/version'

Gem::Specification.new do |gem|
  gem.name          = "mail_car"
  gem.version       = MailCar::VERSION
  gem.authors       = ["S. Christoffer Eliesen"]
  gem.email         = ["christoffer@eliesen.no"]
  gem.description   = %q{MailCar sends you and your team mates a deployment summary after deploying with capistrano.}
  gem.summary       = %q{MailCar sends you and your team mates a deployment summary after deploying with capistrano.}
  gem.homepage      = "http://github.com/sce/mail_car"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "actionmailer", "~> 3.0"
end
