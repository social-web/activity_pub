# frozen_string_literal: true

module RackHelper
  def app
    Rack::Builder.app do
      use SocialWeb::ActivityPub::Rack
      run ->(a) { raise 'This should not be reached '}
    end
  end
end
