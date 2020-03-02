# frozen_string_literal: true

require_relative './concerns/normalize_id'

module SocialWeb
  module ActivityPub
    module Relations
      class Collections < Sequel::Model(SocialWeb::ActivityPub[:db][:social_web_activity_pub_collections])
        include NormalizeID

        dataset_module do
          def by_object_iri(iri)
            where(object_iri: normalize_id(iri))
          end

          def by_actor_iri(iri)
            where(actor_iri: normalize_id(iri))
          end

          def by_type(type)
            where(Sequel[:social_web_activity_pub_collections][:type] => type.to_s)
          end

          def with_objects
            join(:social_web_activity_pub_objects, iri: :object_iri)
          end
        end
      end
    end
  end
end