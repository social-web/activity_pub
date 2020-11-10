require 'social_web/activity_pub/container'

module SocialWeb::ActivityPub
  class Error < StandardError; end
end

SocialWeb::ActivityPub::Container.start :configuration
