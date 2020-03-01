# frozen_string_literal: true

SocialWeb::ActivityPub::Container.boot :activity_pub do
  init do
    use :activity_streams

    require 'social_web/activity_pub/ext/activity_streams_extension'
    ActivityStreams::Actor.extend(ActivityStreams::Extensions::ActivityPub)

    require 'social_web/activity_pub/process'

    require 'social_web/activity_pub/collection'
    container.namespace(:collections) do
      require 'social_web/activity_pub/collections/inbox'
      register(:inbox, SocialWeb::ActivityPub::Collections::Inbox)

      require 'social_web/activity_pub/collections/outbox'
      register(:outbox, SocialWeb::ActivityPub::Collections::Outbox)

      require 'social_web/activity_pub/collections/following'
      register(:following, SocialWeb::ActivityPub::Collections::Following)
    end
  end
end
