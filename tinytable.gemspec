# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tinytable/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Leo Cassarani"]
  gem.email         = ["leo.cassarani@me.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = "https://github.com/leocassarani/tinytable"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "tinytable"
  gem.require_paths = ["lib"]
  gem.version       = TinyTable::VERSION
end
