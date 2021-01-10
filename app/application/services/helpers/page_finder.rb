module DrinkKing
  module Service
    # fill empty field(recommend_drink, menu) to fit shop representer
    class PageFinder
      def initialize
        @posts = PageFinder.load_posts
      end

      def self.load_posts
        file = File.read('assets/shop_post_test.json')
        JSON.parse(file,object_class: OpenStruct)
      end

      def all_posts
        @posts
      end
    end
  end
end
