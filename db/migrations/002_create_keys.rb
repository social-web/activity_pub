# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:social_web_activity_pub_keys) do
      primary_key :id

      String :private, null: false
      String :public, null: false

      Time :created_at, null: false
      Time :updated_at, null: true

      foreign_key :object_id,
        :social_web_activity_pub_objects,
        key: :id,
        type: String,
        on_delete: :cascade,
        on_update: :cascade
      index :object_id, unique: true
    end
  end
end
