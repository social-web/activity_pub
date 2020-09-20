# frozen_string_literal: true

SocialWeb::ActivityPub::Container.boot :commands do
  init do
    container.namespace :commands do
      require 'social_web/activity_pub/commands/follow'
      register(:follow, SocialWeb::ActivityPub::Commands::Follow)
    end
  end
end
