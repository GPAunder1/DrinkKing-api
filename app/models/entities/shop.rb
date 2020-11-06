# frozen_string_literal: false

require_relative 'review'
module CodePraise
  module Entity
    # Domain entity for drink shops
    class Shop < Dry::Struct
      include Dry.Types

      attribute :id,            Strict::String
      attribute :name,          Strict::String
      attribute :address,       Strict::String
      attribute :location,      Strict::Hash
      attribute :phone_number,  Strict::String
      attribute :map_url,       Strict::String
      attribute :opening_now,   Strict::String.optional
      attribute :rating,        Strict::Integer | Strict::Float
      attribute :reviews,       Strict::Array.of(Review)
    end
  end
end
