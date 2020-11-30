# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:shops) do
      primary_key :id

      String      :placeid, null: false
      String      :name, null: false
      String      :address, null: false
      Float       :latitude, null: false
      Float       :longitude, null: false
      String      :phone_number
      String      :map_url
      String      :opening_now
      Float       :rating

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
