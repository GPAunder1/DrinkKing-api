module DrinkKing
  module Service
    # fill empty field(recommend_drink, menu) to fit shop representer
    class PageFinder
      def initialize
        @posts = PageFinder.load_posts
      end

      def self.load_posts
        file = File.read('assets/shop_post.json')
        JSON.parse(file,object_class: OpenStruct)
      end

      def all_posts
        @posts
      end

      def clean_data
        @posts.map do |shop|
          new_post = shop['posts'].reject { |post| post['text'].empty? }
          shop['posts'] = new_post
          shop
        end
      end

      def buy_one_for_one_free
        @posts.reject do |shop|
          new_post = shop['posts'].select { |post| post['text'].include?'買一送一' }
          shop['posts'] = new_post
          shop['posts'].empty?
        end
      end

      def new_drink
        @posts.reject do |shop|
          new_post = shop['posts'].select { |post| post['text'].match? /新品|上市|冬季/ }
          shop['posts'] = new_post
          shop['posts'].empty?
        end
      end
    end
  end
end
