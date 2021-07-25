require 'social_web/activity_pub/container'

module SocialWeb::ActivityPub
  class Error < StandardError; end

  LOG_FORMATTER = lambda do |severity, datetime, progname, msg|
    ::Logger::Formatter.new.call(severity, datetime, 'SocialWeb::ActivityPub', msg)
  end
end

SocialWeb::ActivityPub::Container.start :configuration
