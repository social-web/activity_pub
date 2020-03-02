# frozen_string_literal: true

require_relative './concerns/normalize_id'

module SocialWeb
  module ActivityPub
    module Relations
      class Objects < ::Sequel::Model(SocialWeb::ActivityPub[:db][:social_web_activity_pub_objects])
        include NormalizeID

        set_primary_key :iri

        many_to_many :children,
          class: self,
          graph_join_type: :inner,
          join_table: :social_web_activity_pub_relationships,
          left_key: :parent_iri,
          right_key: :child_iri

        many_to_many :parents,
          class: self,
          graph_join_type: :inner,
          join_table: :social_web_activity_pub_relationships,
          left_key: :child_iri,
          right_key: :parent_iri

        dataset_module do
          def by_iri(iri)
            where(iri: normalize_id(iri))
          end

          def by_type(type)
            where(type: type)
          end

          def traverse_children(iri, depth: SocialWeb::ActivityPub[:config].max_depth)
            SocialWeb::ActivityPub[:db][:threads].
              with_recursive(
                :threads,

                select(
                  Sequel[:social_web_activity_pub_objects][:iri],
                  Sequel[:children][:iri],
                  Sequel[:social_web_activity_pub_objects][:json],
                  Sequel[:children][:json],
                  Sequel[:social_web_activity_pub_relationships][:type],
                  Sequel[:social_web_activity_pub_objects][:created_at]
                ) { 1 }.
                  join(:social_web_activity_pub_relationships, { parent_iri: :iri }).
                  join(Sequel[:social_web_activity_pub_objects].as(:children), { iri: :child_iri }).
                  where(Sequel[:social_web_activity_pub_objects][:iri] => normalize_id(iri)),

                select(
                  Sequel[:social_web_activity_pub_objects][:iri],
                  Sequel[:children][:iri],
                  Sequel[:social_web_activity_pub_objects][:json],
                  Sequel[:children][:json],
                  Sequel[:social_web_activity_pub_relationships][:type],
                  Sequel[:social_web_activity_pub_objects][:created_at]
                ) { Sequel[:depth] + 1 }.
                  join(:social_web_activity_pub_relationships, { parent_iri: :iri }).
                  join(Sequel[:social_web_activity_pub_objects].as(:children), { iri: :child_iri }).
                  join(:threads, Sequel[:threads][:child_iri] => Sequel[:social_web_activity_pub_objects][:iri]).
                  where { Sequel[:threads][:depth] <= depth },

                args: [:parent_iri, :child_iri, :parent_json, :child_json, :rel_type, :created_at, :depth]
              )
          end

          def traverse_parents(iri, depth: SocialWeb::ActivityPub[:config].max_depth)
            SocialWeb::ActivityPub[:db][:threads].
              with_recursive(
                :threads,

                select(
                  Sequel[:social_web_activity_pub_objects][:iri],
                  Sequel[:parents][:iri],
                  Sequel[:social_web_activity_pub_objects][:json],
                  Sequel[:parents][:json],
                  Sequel[:social_web_activity_pub_relationships][:type],
                  Sequel[:social_web_activity_pub_objects][:created_at]
                ) { 1 }.
                  join(:social_web_activity_pub_relationships, { child_iri: :iri }).
                  join(Sequel[:social_web_activity_pub_objects].as(:parents), { iri: :parent_iri }).
                  where(Sequel[:social_web_activity_pub_objects][:iri] => normalize_id(iri)),

                select(
                  Sequel[:social_web_activity_pub_objects][:iri],
                  Sequel[:parents][:iri],
                  Sequel[:social_web_activity_pub_objects][:json],
                  Sequel[:parents][:json],
                  Sequel[:social_web_activity_pub_relationships][:type],
                  Sequel[:social_web_activity_pub_objects][:created_at]
                ) { Sequel[:depth] + 1 }.
                  join(:social_web_activity_pub_relationships, { child_iri: :iri }).
                  join(Sequel[:social_web_activity_pub_objects].as(:parents), { iri: :parent_iri }).
                  join(:threads, Sequel[:threads][:parent_iri] => Sequel[:social_web_activity_pub_objects][:iri]).
                  where { Sequel[:threads][:depth] <= depth },

                args: [:child_iri, :parent_iri, :child_json, :parent_json, :rel_type, :created_at, :depth]
              )
          end
        end
      end
    end
  end
end