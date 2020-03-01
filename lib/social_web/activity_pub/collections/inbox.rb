# frozen_string_literal: true

module SocialWeb
  module ActivityPub
    module Collections
      class Inbox < SocialWeb::ActivityPub::Collection
        TYPE = 'INBOX'

        def process(activity)
          add(activity)

          case activity[:type]
          when 'Create', 'Announce' then return
          when 'Update'
            SocialWeb::ActivityPub['repositories.objects'].replace(activity[:object])
          when 'Delete'
            SocialWeb::ActivityPub['repositories.objects'].delete(activity[:object])
          when 'Accept'
            if SocialWeb::ActivityPub['collections.outbox'].for_actor(actor).include?(activity[:object])
              SocialWeb::ActivityPub['collections.following'].for_actor(actor).add(activity[:actor])
            end
          end
        end
      end
    end
  end
end