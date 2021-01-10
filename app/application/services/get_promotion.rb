require 'dry/transaction'
require_relative 'helpers/page_finder'

module DrinkKing
  module Service
    class Promotion
      include Dry::Transaction
      step :read_shops_page
      # step :get_promotion

      def read_shops_page
        posts = PageFinder.new.all_posts
        posts = Response::ShopsPage.new(posts)

        Success(Response::ApiResult.new(status: :ok, message: posts))
      end
    end
  end
end
