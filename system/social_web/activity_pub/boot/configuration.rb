# frozen_string_literal: true

SocialWeb::ActivityPub::Container.boot :configuration do
  init do
    require 'dry-configurable'

    require 'social_web/activity_pub/configuration'
    register(:config, SocialWeb::ActivityPub.config)
  end
end
