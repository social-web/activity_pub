# frozen_string_literal: true

SocialWeb::ActivityPub::Container.boot :tasks do
  init do
    require 'rake'

    load File.expand_path(File.join(__FILE__, '../../../../../Rakefile'))
  end
end
