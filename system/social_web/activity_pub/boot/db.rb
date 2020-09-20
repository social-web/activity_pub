# frozen_string_literal: true

SocialWeb::ActivityPub::Container.boot :db do
  init do
    require 'sequel'

    db = Sequel.connect(
      ENV.fetch('SOCIAL_WEB_ACTIVITY_PUB_DATABASE_URL'),
      loggers: SocialWeb::ActivityPub[:config].logger
    )

    db.extension :caller_logging

    register(:db, db)
  end

  start do
    SocialWeb::ActivityPub[:db].test_connection
  end

  stop do
    SocialWeb::ActivityPub[:db].disconnect
  end
end
