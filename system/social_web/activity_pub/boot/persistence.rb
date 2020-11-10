# frozen_string_literal: true

SocialWeb::ActivityPub::Container.boot :persistence do
  init do
    use :db

    container.namespace(:relations) do
      require 'social_web/activity_pub/relations/objects'
      register(:objects, SocialWeb::ActivityPub::Relations::Objects)

      require 'social_web/activity_pub/relations/collections'
      register(:collections, SocialWeb::ActivityPub::Relations::Collections)

      require 'social_web/activity_pub/relations/keys'
      register(:keys, SocialWeb::ActivityPub::Relations::Keys)

      require 'social_web/activity_pub/relations/relationships'
      register(:relationships, SocialWeb::ActivityPub::Relations::Relationships)
    end

    container.namespace(:repositories) do
      require 'social_web/activity_pub/repositories/objects'
      register(:objects, SocialWeb::ActivityPub::Repositories::Objects.new)

      require 'social_web/activity_pub/repositories/collections'
      register(:collections, SocialWeb::ActivityPub::Repositories::Collections.new)

      require 'social_web/activity_pub/repositories/relationships'
      register(:relationships, SocialWeb::ActivityPub::Repositories::Relationships.new)

      require 'social_web/activity_pub/repositories/keys'
      register(:keys, SocialWeb::ActivityPub::Repositories::Keys.new)
    end
  end
end
