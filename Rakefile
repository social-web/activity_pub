# frozen_string_literal: true

require 'bundler/setup'
require 'dotenv'
Dotenv.load('.env.dev')

require 'sequel'

migrations_path = File.join(
  Gem::Specification.find_by_name('social_web-activity_pub').gem_dir,
  'db',
  'migrations'
)

tables = %i[
  social_web_activity_pub_collections
  social_web_activity_pub_keys
  social_web_activity_pub_relationships
  social_web_activity_pub_objects
  social_web_activity_pub_schema_migrations
]
def db
  @db ||= begin
    SocialWeb::ActivityPub.container.start(:db)
    SocialWeb::ActivityPub[:db]
  end
end

namespace :social_web do
  namespace :activity_pub do
    namespace :db do
      desc 'Remove SocialWeb tables'
      task :drop_tables do
        db.transaction do
          db.drop_table?(*tables)
          puts 'Removed SocialWeb tables. ' \
            'Run `rake social_web:activity_pub:db:migrate` to add them.'
        end
      end

      desc 'Create SocialWeb tables'
      task :migrate do
        Sequel.extension :migration, :core_extensions

        db.transaction do
          Sequel::Migrator.run(
            db,
            migrations_path,
            table: :social_web_activity_pub_schema_migrations
          )
          puts 'Created SocialWeb tables. ' \
            'Run `rake social_web:activity_pub:db:drop_tables` to remove them.'
        end
      end

      desc 'Print SocialWeb migrations'
      task :print_migrations do
        Dir[File.join(migrations_path, '*.rb')].each do |migration|
          puts File.read(migration)
        end
      end
    end
  end
end
