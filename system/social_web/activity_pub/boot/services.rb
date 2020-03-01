# frozen_string_literal: true

SocialWeb::ActivityPub::Container.boot :services do
  init do

    require 'social_web/activity_pub/services/dereference'
    register('services.dereference', SocialWeb::ActivityPub::Services::Dereference)

    require 'social_web/activity_pub/services/http_client'
    register('services.http_client', SocialWeb::ActivityPub::Services::HTTPClient)

    require 'social_web/activity_pub/services/reconstitute'
    register('services.reconstitute', SocialWeb::ActivityPub::Services::Reconstitute.new)
  end
end
