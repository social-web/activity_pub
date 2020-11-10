# frozen_string_literal: true

require 'forwardable'

module SocialWeb
  module ActivityPub
    module Repositories
      class Objects
        class Cache
          extend Forwardable

          def initialize(cache = {})
            @cache = cache
          end

          def fetch(id)
            @cache[id] || @cache[id] = yield
          end

          def_delegator :@cache, :[], :get
          def_delegator :@cache, :[]=, :set
        end

        def get_by_id(id)
          found = objects.by_id(id).first
          return if found.nil?

          obj = ActivityStreams.from_json(found[:json])

          # TODO: Reconsistute separately
          SocialWeb::ActivityPub['services.reconstitute'].call(obj)
          obj
        end

        def delete(obj)
          objects.by_id(obj[:id]).delete
          true
        end

        def replace(obj)
          compressed = obj.compress
          objects.by_id(obj[:id]).update(json: obj.to_json)
          true
        end

        def store(obj)
          return obj if stored?(obj) || !obj[:id]

          compressed = obj.compress

          objects.insert(
            id: compressed[:id],
            type: compressed[:type],
            json: compressed.to_json,
            created_at: Time.now.utc
          )

          obj
        end

        def total
          objects.count
        end

        # Traverse the tree of relationships starting with `root`, visiting
        # each relationship with the provided block.
        def traverse(root, properties = [], depth: SocialWeb::ActivityPub[:config].max_depth)
          cache = Cache.new
          cache.set(root[:id], root)

          tree =  objects.traverse_children(root[:id]).all +
            objects.traverse_parents(root[:id]).all
          tree.each do |property_map|
            keys = %i[parent_id parent_json child_id child_json rel_type]
            parent_id,
              parent_json,
              child_id,
              child_json,
              rel_type = property_map.values_at(*keys)

            parent = cache.fetch(parent_id) { ActivityStreams.from_json(parent_json) }
            child = cache.fetch(child_id) { ActivityStreams.from_json(child_json) }

            yield(parent: parent, child: child, property: rel_type)

            child
          end
        end

        private

        def objects
          SocialWeb::ActivityPub['relations.objects']
        end

        def stored?(obj)
          return false unless obj[:id]

          found = objects.by_id(obj[:id]).first
          !found.nil?
        end
      end
    end
  end
end
