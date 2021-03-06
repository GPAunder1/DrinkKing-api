# frozen_string_literal: true

module DrinkKing
  module Repository
    # Find the right Repository for an entity object or class
    class For
      ENTITY_REPOSITORY = {
        Entity::Shop => Shops,
        Entity::Review => Reviews
      }.freeze

      def self.klass(entity_klass)
        ENTITY_REPOSITORY[entity_klass]
      end

      def self.entity(entity_object)
        ENTITY_REPOSITORY[entity_object.class]
      end
    end
  end
end
