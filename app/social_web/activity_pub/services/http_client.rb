# frozen_string_literal: true

require 'http'

module SocialWeb
  module ActivityPub
    module Services
      class HTTPClient
        class RequestError < StandardError; end

        LD_JSON_MIME_TYPE = 'application/ld+json; profile="https://www.w3.org/ns/activitystreams"'
        ACTIVITY_JSON_MIME_TYPE = "#{LD_JSON_MIME_TYPE}; application/activity+json"

        Signature = ->(request, key_id:, private_key:) {
          signing_headers = request.headers.to_h.merge(
            '(request-target)' => "#{request.verb.downcase} #{request.uri.path}"
          ).transform_keys(&:downcase)

          signing_string = signing_headers.
            map { |field, value| "#{field}: #{value}" }.
            join("\n")

          keypair = OpenSSL::PKey::RSA.new(private_key)
          signature = keypair.sign(OpenSSL::Digest::SHA256.new, signing_string)

          format(
            'headers="%<headers>s",keyId="%<keyId>s",signature="%<signature>s"',
            headers: signing_headers.keys.join(' '),
            keyId: key_id,
            signature: Base64.strict_encode64(signature)
          )
        }

        def self.for_actor(actor)
          new(actor)
        end

        def initialize(for_actor)
          @actor = for_actor
        end

        # @param [String] id
        # @return [nil, ActivityStreams]
        def get(id)
          request = http_client.build_request(:get, id)
          request.headers[:accept] = ACTIVITY_JSON_MIME_TYPE
          sign_request(request)

          res = perform(request)
          if res.status.success?
            ActivityStreams.from_json(res.body.to_s)
          else
            SocialWeb::ActivityPub[:config].logger.error(request_error(res))
            nil
          end
        end

        # @param [ActivityStreams] object
        # @param [String] to_collection
        # @return [TrueClass, FalseClass]
        def post(object:, to_collection:)
          request = http_client.build_request(
            :post,
            to_collection.is_a?(ActivityStreams) ? to_collection[:id] : to_collection,
            body: object.compress.to_json
          )
          request.headers['content-type'] = LD_JSON_MIME_TYPE
          request = sign_request(request)

          res = perform(request)

          if res.status.success?
            true
          else
            SocialWeb::ActivityPub[:config].logger.error(request_error(res))
            false
          end
        end

        private

        attr_reader :actor

        def perform(request)
          client = ::HTTP::Client.new
          client.perform(request, client.default_options)
        end

        def request_error(request, response)
          exception = RequestError.new(response.body.to_s)
          exception.set_caller(caller)
          exception.full_message
        end

        def signature(request)
          keys = SocialWeb::ActivityPub['repositories.keys'].get_keys_for(actor)

          Signature.call(
            request,
            private_key: keys.fetch(:private),
            key_id: keys.fetch(:key_id)
          )
        end

        def http_client
          ::HTTP.
            use(logging: { logger: SocialWeb::ActivityPub[:config].logger }).
            headers(date: Time.now.utc.httpdate)
        end

        def sign_request(request)
          request.headers.merge!(signature: signature(request))
          request
        end
      end
    end
  end
end
