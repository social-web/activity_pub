# frozen_string_literal: true

require 'logger'

module SocialWeb
  module ActivityPub
    extend ::Dry::Configurable

    setting(:database_params)
    setting(:database_url, ENV['SOCIAL_WEB_ACTIVITY_PUB_DATABASE_URL'])
    setting(
      :logger,
      ::Logger.new(
        STDOUT,
        formatter: lambda do |severity, datetime, progname, msg|
          ::Logger::Formatter.new.call(severity, datetime, 'SocialWeb::ActivityPub', msg)
        end
      )
    )
    setting(:collections, %i[inbox outbox].freeze) { |collection| Array(collection).freeze }
    setting(:base_url) { |url| url&.gsub(/\/$/, '') }

    # When traversing an ActivityStream's property tree, how deep should we go
    setting :max_depth, 200
  end
end
