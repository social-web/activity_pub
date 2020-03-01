# frozen_string_literal: true

module SocialWeb
  module ActivityPub
    def self.process(activity_json, actor_iri, collection)
      SocialWeb::ActivityPub[:config].logger.debug <<~MSG
        Processing:
  
        activity_json: #{activity_json}
        actor_iri: #{actor_iri}
        collection: #{collection}
      MSG

      activity = ActivityStreams.from_json(activity_json)
      actor = SocialWeb::ActivityPub['repositories.objects'].get_by_iri(actor_iri)

      SocialWeb::ActivityPub['repositories.objects'].store(activity)

      activity = SocialWeb::ActivityPub['services.dereference'].for_actor(actor).call(activity)
      activity = SocialWeb::ActivityPub['services.reconstitute'].call(activity)

      SocialWeb::ActivityPub["collections.#{collection}"].for_actor(actor).process(activity)
    end
  end
end