# frozen_string_literal: true

SocialWeb::ActivityPub::Container.boot :logging do
  init do
    use :configuration

    require 'logger'

    SocialWeb::ActivityPub::LOG_FORMATTER = lambda do |severity, datetime, progname, msg|
      ::Logger::Formatter.new.call(severity, datetime, 'SocialWeb::ActivityPub', msg)
    end

    register(
      :logger,
      SocialWeb::ActivityPub.config.logger
    )
  end
end
