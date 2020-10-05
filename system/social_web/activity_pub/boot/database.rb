# frozen_string_literal: true

SocialWeb::ActivityPub::Container.boot :database do
  init do
    use :configuration
    require 'sequel'

    db = Sequel.connect(
      SocialWeb::ActivityPub[:config].database_url || SocialWeb::ActivityPub[:config].database_params,
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
