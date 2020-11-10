# frozen_string_literal: true

SocialWeb::ActivityPub::Container.boot :db do
  init do
    use :configuration
    require 'sequel'

    db_url = SocialWeb::ActivityPub[:config].database_url
    db_params = SocialWeb::ActivityPub[:config].database_params

    if !db_url && !db_params
      raise ::SocialWeb::ActivityPub::Error, 'A database url string or database params hash is required.'
    end

    db = Sequel.connect(
      db_url || db_params,
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
