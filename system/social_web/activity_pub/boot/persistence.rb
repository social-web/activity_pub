# frozen_string_literal: true

SocialWeb::ActivityPub::Container.boot :persistence do
  init do
    use :db

    container.namespace(:relations) do
      require 'social_web/activity_pub/relations/objects'
      register(:objects, SocialWeb::Relations::Objects)

      require 'social_web/activity_pub/relations/collections'
      register(:collections, SocialWeb::Relations::Collections)

      require 'social_web/activity_pub/relations/keys'
      register(:keys, SocialWeb::Relations::Keys)

      require 'social_web/activity_pub/relations/relationships'
      register(:relationships, SocialWeb::Relations::Relationships)
    end


    container.namespace(:repositories) do
      require 'social_web/activity_pub/repositories/objects'
      register(:objects, SocialWeb::Repositories::Objects.new)

      require 'social_web/activity_pub/repositories/collections'
      register(:collections, SocialWeb::Repositories::Collections.new)

      require 'social_web/activity_pub/repositories/relationships'
      register(:relationships, SocialWeb::Repositories::Relationships.new)

      require 'social_web/activity_pub/repositories/keys'
      register(:keys, SocialWeb::Repositories::Keys.new)
    end
  end
end
