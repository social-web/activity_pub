# frozen_string_literal: true

module SocialWeb
  module ActivityPub
    module Services
      # Retrieve and assign object's nested relationships
      class Reconstitute
        def call(obj)
          obj = obj.dup
          SocialWeb::ActivityPub['repositories.objects'].traverse(obj) do |prop_map|
            parent, child, prop = prop_map.values_at(:parent, :child, :property)
            parent[prop] = child
            next unless child

            # Add replies to child's replies and also to given object's replies
            if prop == 'inReplyTo' && child[:replies]
              child[:replies][:items] ||= []
              child[:replies][:items] << parent

              if obj[:replies]
                obj[:replies][:items] ||= []
                obj[:replies][:items] << parent
              end
            end
          end

          keys = SocialWeb::ActivityPub['repositories.keys'].get_keys_for(obj)
          if keys
            obj[:publicKey] = {
              id: keys[:key_id],
              owner: obj[:id],
              publicKeyPem: keys[:public]
            }
          end

          obj
        end
      end
    end
  end
end