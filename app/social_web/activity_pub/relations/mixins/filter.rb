# frozen_string_literal: true

module SocialWeb
  module ActivityPub
    module Relations
      module Filter
        dataset_module do
          def filter(**filters)
            where(filters)
          end
        end
      end
    end
  end
end
