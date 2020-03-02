# frozen_string_literal: true

SocialWeb::ActivityPub::Container.boot :logging do
  init do
    require 'logger'

    SocialWeb::ActivityPub::LOG_FORMATTER = lambda do |severity, datetime, progname, msg|
      ::Logger::Formatter.new.call(severity, datetime, 'SocialWeb::ActivityPub', msg)
    end

    register(:logger, ::Logger.new(STDOUT, formatter: SocialWeb::ActivityPub::LOG_FORMATTER))
  end
end
