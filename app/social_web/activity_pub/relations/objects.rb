# frozen_string_literal: true

module SocialWeb
  module ActivityPub
    module Relations
      class Objects < ::Sequel::Model(SocialWeb::ActivityPub[:db][:social_web_activity_pub_objects])
        set_primary_key :id

        many_to_many :children,
          class: self,
          graph_join_type: :inner,
          join_table: :social_web_activity_pub_relationships,
          left_key: :parent_id,
          right_key: :child_id

        many_to_many :parents,
          class: self,
          graph_join_type: :inner,
          join_table: :social_web_activity_pub_relationships,
          left_key: :child_id,
          right_key: :parent_id

        dataset_module do
          def by_id(id)
            where(id: id)
          end

          def by_type(type)
            where(type: type)
          end

          def traverse_children(id, depth: SocialWeb::ActivityPub[:config].max_depth)
            SocialWeb::ActivityPub[:db][:threads].
              with_recursive(
                :threads,

                select(
                  Sequel[:social_web_activity_pub_objects][:id],
                  Sequel[:children][:id],
                  Sequel[:social_web_activity_pub_objects][:json],
                  Sequel[:children][:json],
                  Sequel[:social_web_activity_pub_relationships][:type],
                  Sequel[:social_web_activity_pub_objects][:created_at]
                ) { 1 }.
                  join(:social_web_activity_pub_relationships, { parent_id: :id }).
                  join(Sequel[:social_web_activity_pub_objects].as(:children), { id: :child_id }).
                  where(Sequel[:social_web_activity_pub_objects][:id] => id),

                select(
                  Sequel[:social_web_activity_pub_objects][:id],
                  Sequel[:children][:id],
                  Sequel[:social_web_activity_pub_objects][:json],
                  Sequel[:children][:json],
                  Sequel[:social_web_activity_pub_relationships][:type],
                  Sequel[:social_web_activity_pub_objects][:created_at]
                ) { Sequel[:depth] + 1 }.
                  join(:social_web_activity_pub_relationships, { parent_id: :id }).
                  join(Sequel[:social_web_activity_pub_objects].as(:children), { id: :child_id }).
                  join(:threads, Sequel[:threads][:child_id] => Sequel[:social_web_activity_pub_objects][:id]).
                  where { Sequel[:threads][:depth] <= depth },

                args: [:parent_id, :child_id, :parent_json, :child_json, :rel_type, :created_at, :depth]
              )
          end

          def traverse_parents(id, depth: SocialWeb::ActivityPub[:config].max_depth)
            SocialWeb::ActivityPub[:db][:threads].
              with_recursive(
                :threads,

                select(
                  Sequel[:social_web_activity_pub_objects][:id],
                  Sequel[:parents][:id],
                  Sequel[:social_web_activity_pub_objects][:json],
                  Sequel[:parents][:json],
                  Sequel[:social_web_activity_pub_relationships][:type],
                  Sequel[:social_web_activity_pub_objects][:created_at]
                ) { 1 }.
                  join(:social_web_activity_pub_relationships, { child_id: :id }).
                  join(Sequel[:social_web_activity_pub_objects].as(:parents), { id: :parent_id }).
                  where(Sequel[:social_web_activity_pub_objects][:id] => id),

                select(
                  Sequel[:social_web_activity_pub_objects][:id],
                  Sequel[:parents][:id],
                  Sequel[:social_web_activity_pub_objects][:json],
                  Sequel[:parents][:json],
                  Sequel[:social_web_activity_pub_relationships][:type],
                  Sequel[:social_web_activity_pub_objects][:created_at]
                ) { Sequel[:depth] + 1 }.
                  join(:social_web_activity_pub_relationships, { child_id: :id }).
                  join(Sequel[:social_web_activity_pub_objects].as(:parents), { id: :parent_id }).
                  join(:threads, Sequel[:threads][:parent_id] => Sequel[:social_web_activity_pub_objects][:id]).
                  where { Sequel[:threads][:depth] <= depth },

                args: [:child_id, :parent_id, :child_json, :parent_json, :rel_type, :created_at, :depth]
              )
          end
        end
      end
    end
  end
end
