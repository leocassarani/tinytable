# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tinytable/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Leo Cassarani"]
  gem.email         = ["leo.cassarani@me.com"]
  gem.description   = %q{Simple ASCII table generation in Ruby.}
  gem.summary       = %q{TinyTable lets you create and output simple ASCII tables with minimal effort.}
  gem.homepage      = "https://github.com/leocassarani/tinytable"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "tinytable"
  gem.require_paths = ["lib"]
  gem.version       = TinyTable::VERSION

  gem.add_development_dependency "rake", "~> 0.9.2"
  gem.add_development_dependency "rspec", "~> 2.11.0"
end
