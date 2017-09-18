# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'databranch/version'

Gem::Specification.new do |spec|
  spec.name          = "databranch"
  spec.version       = Databranch::VERSION
  spec.authors       = ["Guru Khalsa"]
  spec.email         = ["guru5997@me.com"]

  spec.summary       = %q{Implements database branching in development and test by cloning the database automatically, supplementing Git branching workflow.}
  spec.description   = %q{Implements database branching in development and test by cloning the database automatically, supplementing Git branching workflow.  This prevents situations where the database becomes stale due to schema or data inconsistencies between git branches.  It automates the process of creating and deleting branch database copies by hooking into git.}
  spec.homepage      = "http://rubygems.org/gems/databranch"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  # spec.files         = [`git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.files         = ["lib/databranch.rb", "lib/databranch/railtie.rb", "lib/databranch/version.rb", "lib/tasks/databranch.rake", "lib/hooks/post_checkout/post-checkout", "lib/hooks/post_checkout/databranch-post-checkout", "lib/hooks/post_commit/post-commit", "lib/hooks/post_commit/databranch-post-commit"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_runtime_dependency "pg", "~>0.19"
end
