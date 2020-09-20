# frozen_string_literal: true

module SocialWeb
  module ActivityPub
    module Commands
      class Follow
        def self.for_actor(actor)
          new(for_actor: actor)
        end

        def initialize(for_actor:)
          @actor = for_actor
        end

        def call(iri)
          followee = SocialWeb::ActivityPub['services.http_client'].for_actor(@actor).get(iri)
          follow = ActivityStreams.follow(actor: @actor, object: followee)
          SocialWeb::ActivityPub['collections.outbox'].for_actor(@actor).process(follow)
        end
      end
    end
  end
end
