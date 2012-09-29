# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'brief_mail/version'

Gem::Specification.new do |gem|
  gem.name          = "brief_mail"
  gem.version       = BriefMail::VERSION
  gem.authors       = ["S. Christoffer Eliesen"]
  gem.email         = ["christoffer@eliesen.no"]
  gem.description   = %q{BriefMail sends you and your team mates a deployment summary after deploying with capistrano.}
  gem.summary       = %q{BriefMail sends you and your team mates a deployment summary after deploying with capistrano.}
  gem.homepage      = "http://github.com/sce/brief_mail"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "actionmailer", "~> 3.0"

  gem.add_development_dependency "minitest", "~> 4.0"
  gem.add_development_dependency "rake", "~> 0.9"
end
