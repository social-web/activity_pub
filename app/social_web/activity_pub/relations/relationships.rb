# frozen_string_literal: true

module SocialWeb
  module ActivityPub
    module Relations
      class Relationships < Sequel::Model(SocialWeb::ActivityPub[:db][:social_web_activity_pub_relationships])
        dataset_module do
          def by_child_id(id)
            where(child_id: id)
          end

          def by_parent_id(id)
            where(parent_id: id)
          end

          def by_type(type)
            where(type: type)
          end
        end
      end
    end
  end
end
