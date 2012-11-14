# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acts_as_discontinued/version'

Gem::Specification.new do |gem|
  gem.name          = "acts_as_discontinued"
  gem.version       = ActsAsDiscontinued::VERSION
  gem.authors       = ["Emmanuel Nicolau"]
  gem.email         = ["emmanicolau@gmail.com"]
  gem.description   = %q{Another paranoid gem}
  gem.summary       = %q{Another paranoid gem}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency "activerecord", '>= 3.0.0'
  gem.add_development_dependency "sqlite3"
end
