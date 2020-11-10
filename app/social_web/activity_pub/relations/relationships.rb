# frozen_string_literal: true

module SocialWeb
  module ActivityPub
    module Relations
      class Relationships < Sequel::Model(SocialWeb::ActivityPub[:db][:social_web_activity_pub_relationships])
        dataset_module do
          def by_child_iri(iri)
            where(child_iri: iri)
          end

          def by_parent_iri(iri)
            where(parent_iri: iri)
          end

          def by_type(type)
            where(type: type)
          end
        end
      end
    end
  end
end
