# frozen_string_literal: false

require_relative 'review'
module DrinkKing
  module Entity
    # Domain entity for drink shops
    class Shop < Dry::Struct
      include Dry.Types

      attribute :id,            Strict::Integer.optional
      attribute :placeid,       Strict::String
      attribute :name,          Strict::String
      attribute :address,       Strict::String
      attribute :latitude,      Strict::Float
      attribute :longitude,     Strict::Float
      attribute :phone_number,  Strict::String.optional
      attribute :map_url,       Strict::String
      attribute :opening_now,   Strict::String.optional
      attribute :rating,        Strict::Integer | Strict::Float
      attribute :reviews,       Strict::Array.of(Review)

      def to_attr_hash
        to_hash.reject { |key, _| %i[id reviews].include? key }
      end
    end
  end
end
