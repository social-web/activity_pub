# frozen_string_literal: true

module SocialWeb
  module ActivityPub
    module Services
      # Determine which addresses to deliver to
      class TargetDelivery
        FIELDS = %i[to bto cc bcc audience].freeze

        def self.for_actor(actor)
          new(actor)
        end

        def initialize(actor)
          @objects_repo = SocialWeb::ActivityPub['repositories.objects']
          @actor = actor
          @inboxes = []
        end

        def call(obj)
          field_values = obj.to_h.values_at(FIELDS)

          field_values.each do |value|
            case value
            when String
              obj = @objects_repo.get_by_iri(iri)
              @inbox << obj.inbox
            when ActivityStreams::Collection

            end
          end
        end

        private

        def retrieve_inboxes(obj)
          case obj
          when ActivityStreams::Actor then obj.inbox
          when ActivityStreams::Collection
            obj.traverse_items do ||
          end
        end
      end
    end
  end
end
