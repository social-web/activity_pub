# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'social_web-activity_pub'
  s.version = '0.1'
  s.description = 'An ActivityPub implementation'
  s.summary = 'Provides business logic, an HTTP adapter for access, and relational storage'

  s.license = 'MIT'

  s.authors = ['Shane Cavanaugh']
  s.email = ['shane@shanecav.net']
  s.homepage = 'https://github.com/social-web/activity_pub'

  s.files = %w[README.md Rakefile LICENSE.txt] + Dir['{app,db,lib,system}/**/*']
  s.require_paths = %w[system]

  s.required_ruby_version = '>= 2.5.0'

  s.add_dependency 'dry-container'
  s.add_dependency 'dry-configurable'
  s.add_dependency 'dry-system'

  # Provides easy access to an HTTP client
  s.add_dependency 'http'

  # Provides Ruby models to represent Activity Streams objects
  s.add_dependency 'social_web-activity_streams'

  # Provides a framework for efficient routing of requests
  s.add_dependency 'roda'

  # Provides a database toolkit for persistance
  s.add_dependency 'sequel'

  s.add_development_dependency 'bundler', '~> 2.0'
  s.add_development_dependency 'dotenv', '~> 2.0'
  s.add_development_dependency 'dry-auto_inject'
  s.add_development_dependency 'factory_bot'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'rack-test', '~> 1.0'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'simplecov', '~> 0.1'
  s.add_development_dependency 'sqlite3'
end
