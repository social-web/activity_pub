# frozen_string_literal: true

module SocialWeb
  module ActivityPub
    # A collection is a domain-level repo intended to be used by domain models
    # for storage access
    class Collection
      def self.for_actor(actor)
        new(actor)
      end

      def initialize(for_actor)
        @actor = for_actor
      end

      def add(obj)
        SocialWeb::ActivityPub['repositories.objects'].store(obj)
        SocialWeb::ActivityPub['repositories.collections'].
          store_object_in_collection_for_actor(
            object: obj,
            collection: self.class::TYPE.downcase,
            actor: actor
          )
        true
      end

      def include?(obj)
        SocialWeb::ActivityPub['repositories.collections'].stored?(
          object: obj,
          collection: self.class::TYPE.downcase,
          actor: actor
        )
      end

      private

      attr_reader :actor
    end
  end
end