# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:social_web_activity_pub_objects) do
      primary_key :id, type: String

      String :json, null: false

      String :type, null: false
      index :type

      Time :created_at, null: false
      Time :updated_at, null: true
    end

    create_table(:social_web_activity_pub_relationships) do
      primary_key :id

      String :type, null: false
      foreign_key :parent_id,
        :social_web_activity_pub_objects,
        key: :id,
        on_delete: :cascade,
        on_update: :cascade,
        type: String
      foreign_key :child_id,
        :social_web_activity_pub_objects,
        key: :id,
        on_delete: :cascade,
        on_update: :cascade,
        type: String


      Time :created_at, null: false
      Time :updated_at, null: true

      index %i[child_id parent_id type], unique: true
    end

    create_table(:social_web_activity_pub_collections) do
      primary_key :id

      String :type, null: false
      foreign_key :actor_id,
        :social_web_activity_pub_objects,
        key: :id,
        on_delete: :cascade,
        on_update: :cascade,
        type: String
      foreign_key :object_id,
        :social_web_activity_pub_objects,
        key: :id,
        on_delete: :cascade,
        on_update: :cascade,
        type: String

      Time :created_at, null: false
      Time :updated_at, null: true

      index %i[type actor_id object_id], unique: true
    end
  end
end
