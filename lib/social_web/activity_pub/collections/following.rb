# frozen_string_literal: true

module SocialWeb
  module ActivityPub
    module Collections
      class Following < SocialWeb::ActivityPub::Collection
        TYPE = 'Following'
      end
    end
  end
end