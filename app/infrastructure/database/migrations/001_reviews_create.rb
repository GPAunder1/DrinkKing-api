# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:reviews) do
      primary_key :id
      foreign_key :shop_id, :shops, on_delete: :cascade, on_update: :cascade

      String      :author, null: false
      Fixnum      :rating, null: false
      String      :relative_time
      String      :content, text: true, null: false

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
