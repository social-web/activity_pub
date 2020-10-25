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

        # TODO:
        #   Add caching:
        #   1. Access via memory cache
        #   2. Access via database
        #   3. Access via dereferencer
        def get_by_iri(iri)
          found = objects.by_iri(iri).first
          return if found.nil?

          obj = ActivityStreams.from_json(found[:json])

          # TODO: Reconsistute separately
          SocialWeb::ActivityPub['services.reconstitute'].call(obj)
          obj
        end

        def delete(obj)
          objects.by_iri(obj[:id]).delete
          true
        end

        def replace(obj)
          compressed = obj.compress
          objects.by_iri(obj[:id]).update(json: obj.to_json)
          true
        end

        def store(obj)
          return obj if stored?(obj) || !obj[:id]

          compressed = obj.compress

          objects.insert(
            iri: compressed[:id],
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
            keys = %i[parent_iri parent_json child_iri child_json rel_type]
            parent_iri,
              parent_json,
              child_iri,
              child_json,
              rel_type = property_map.values_at(*keys)

            parent = cache.fetch(parent_iri) { ActivityStreams.from_json(parent_json) }
            child = cache.fetch(child_iri) { ActivityStreams.from_json(child_json) }

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

          found = objects.by_iri(obj[:id]).first
          !found.nil?
        end
      end
    end
  end
end
