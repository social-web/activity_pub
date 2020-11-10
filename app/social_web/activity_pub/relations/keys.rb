# frozen_string_literal: true

module SocialWeb
  module ActivityPub
    module Relations
      class Keys < Sequel::Model(SocialWeb::ActivityPub[:db][:social_web_activity_pub_keys])
        dataset_module do
          def by_object_iri(iri)
            where(object_iri: iri)
          end
        end
      end
    end
  end
end
