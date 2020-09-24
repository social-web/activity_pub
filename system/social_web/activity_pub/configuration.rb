# frozen_string_literal: true

module SocialWeb
  module ActivityPub
    extend ::Dry::Configurable

    setting(:database_params)
    setting(:database_url, ENV['SOCIAL_WEB_ACTIVITY_PUB_DATABASE_URL'])
    setting(:logger, SocialWeb::ActivityPub[:logger])
    setting(:collections, %i[inbox outbox].freeze) { |collection| Array(collection).freeze }
    setting(:base_url) { |url| url&.gsub(/\/$/, '') }

    # When traversing an ActivityStream's property tree, how deep should we go
    setting :max_depth, 200
  end
end
