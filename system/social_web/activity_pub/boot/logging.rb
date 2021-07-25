# frozen_string_literal: true

SocialWeb::ActivityPub::Container.boot :logging do
  init do
    use :configuration

    require 'logger'

    register(
      :logger,
      SocialWeb::ActivityPub.config.logger
    )
  end
end
