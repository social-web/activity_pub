# frozen_string_literal: true

module SocialWeb
  module ActivityPub
    module Relations
      class Collections < Sequel::Model(SocialWeb::ActivityPub[:db][:social_web_activity_pub_collections])
        dataset_module do
          def by_object_id(id)
            where(object_id: id)
          end

          def by_actor_id(id)
            where(actor_id: id)
          end

          def by_type(type)
            where(Sequel[:social_web_activity_pub_collections][:type] => type.to_s)
          end

          def with_objects
            join(:social_web_activity_pub_objects, id: :object_id)
          end
        end
      end
    end
  end
end
