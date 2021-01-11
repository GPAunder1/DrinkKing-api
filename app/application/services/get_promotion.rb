require 'dry/transaction'
require_relative 'helpers/page_finder'

module DrinkKing
  module Service
    class Promotion
      include Dry::Transaction
      step :read_shops_page
      # step :get_promotion

      def read_shops_page(input)
        keyword = input[:keyword]
        # posts = PageFinder.new.all_posts
        posts = PageFinder.new.buy_one_for_one_free if keyword == 'one_free'
        posts = PageFinder.new.new_drink if keyword == 'new_drink'
        posts = Response::ShopsPage.new(posts)

        Success(Response::ApiResult.new(status: :ok, message: posts))
      end
    end
  end
end
