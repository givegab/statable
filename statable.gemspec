# -*- encoding: utf-8 -*-
require File.expand_path('../lib/statable/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["iYouVo"]
  gem.email         = ["michal.kuklis@gmail.com"]
  gem.description   = %q{Wrapper around Active Record and Redis Objects}
  gem.summary       = %q{Wrapper around Active Record and Redis Objects}
  gem.homepage      = ""
  
  gem.add_dependency 'redis'
  gem.add_dependency 'redis-objects'
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "sqlite3"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "statable"
  gem.require_paths = ["lib"]
  gem.version       = Statable::VERSION
end
