# frozen_string_literal: true

SocialWeb::ActivityPub::Container.boot :routes do
  init do
    require 'roda'
    require 'social_web/activity_pub/routes'

    register(:routes, SocialWeb::ActivityPub::Routes)
  end
end
