# frozen_string_literal: true

SocialWeb::ActivityPub::Container.boot :activity_streams do
  init do
    require 'activity_streams'
  end
end
