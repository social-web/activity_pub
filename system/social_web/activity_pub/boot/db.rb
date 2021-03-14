# frozen_string_literal: true

SocialWeb::ActivityPub::Container.boot :db do
  init do
    use :configuration
    require 'sequel'
  end

  start do
    db_url = SocialWeb::ActivityPub[:config].database_url
    db_params = SocialWeb::ActivityPub[:config].database_params

    if !db_url && !db_params
      raise ::SocialWeb::ActivityPub::Error, 'A database url string or database params hash is required.'
    end

    db = Sequel.connect(
      db_url || db_params,
      logger: SocialWeb::ActivityPub[:config].logger
    )

    db.extension :caller_logging

    db.test_connection
    register(:db, db)
  end

  stop do
    SocialWeb::ActivityPub[:db].disconnect
  end
end
