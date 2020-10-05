# frozen_string_literal: true

SocialWeb::ActivityPub::Container.boot :message_bus do
  init do
    use :database
    use :logging
    require 'message_bus'

    MessageBus.configure(
      backend: :postgres,
      backend_options: SocialWeb::ActivityPub[:db].uri,
      on_middleware_error: proc do |env, e|
        SocialWeb::ActivityPub[:logger].error(e)
      end
    )

    register(:message_bus, MessageBus)
  end
end
