# frozen_string_literal: true

require 'bundler/setup'
require 'dotenv'
Dotenv.load('.env.dev')
require 'social_web/activity_pub'

SocialWeb::ActivityPub.container.start :routes

use SocialWeb::ActivityPub::Rack

run ->(app) { [200, {}, []] }
