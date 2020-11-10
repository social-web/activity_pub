# frozen_string_literal: true

require 'roda/session_middleware'

module SocialWeb
  module ActivityPub
    module Rack
      def self.new(app, *args, &block)
        SocialWeb::ActivityPub::Container.finalize!
        SocialWeb::ActivityPub::Routes.new(app, *args, &block)
      end
    end

    class Routes < ::Roda
      ACTIVITY_JSON_MIME_TYPES = [
        'application/ld+json; profile="https://www.w3.org/ns/activitystreams',
        'application/activity+json'
      ].freeze
      COLLECTION_REGEX = /(#{SocialWeb::ActivityPub[:config].collections.join('|')})/i.freeze

      plugin :middleware
      plugin :common_logger, SocialWeb::ActivityPub[:config].logger
      plugin :header_matchers

      route do |r|
        r.on [{ header: 'accept' }, { header: 'content-type' }] do |content_type|
          return unless relevant_content_type?(content_type)

          id = r.url
          actor_id = parse_actor_id(id)
          collection_type= parse_collection(id)

          r.get do
            r.on(/.*#{COLLECTION_REGEX}/) do |collection_type|
              actor = SocialWeb::ActivityPub['repositories.objects'].get_by_id(actor_id)
              collection = SocialWeb::ActivityPub['repositories.collections'].
                get_collection_for_actor(actor: actor, collection: collection_type)

              response.headers['content-type'] = ACTIVITY_JSON_MIME_TYPES.join(',')
              collection.to_json
            end

            found = SocialWeb::ActivityPub['repositories.objects'].get_by_id(id)
            if found.nil?
              response.status = 404
              nil
            else
              found.to_json
            end
          end

          r.post do
            activity_json = r.body.read
            SocialWeb::ActivityPub.process(activity_json, actor_id, collection_type)
            response.status = 201
            ''
          end
        end
      end

      def parse_actor_id(url)
        match = url.match(/(.*)\/#{COLLECTION_REGEX}/)
        match ? match[1] : url
      end

      def parse_collection(url)
        url[COLLECTION_REGEX]
      end

      def relevant_content_type?(content_type)
        ACTIVITY_JSON_MIME_TYPES.any? { |type| content_type.include?(type) }
      end
    end
  end
end
