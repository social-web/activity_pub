# frozen_string_literal: true

require 'dry/system/container'

module SocialWeb
  module ActivityPub
    def self.[](key)
      container[key]
    end

    def self.container
      @container ||= Container
    end

    class Container < Dry::System::Container
      configure do |config|
        config.default_namespace = 'social_web.activity_pub'
        config.root = Pathname(File.join(__dir__, '..', '..', '..')).realpath.freeze
        config.system_dir = 'system/social_web/activity_pub'
      end

      load_paths!('app')
      load_paths!('lib')
      load_paths!('system')
    end
  end
end