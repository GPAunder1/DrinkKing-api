# frozen_string_literal: true

require 'roda'
require_relative 'lib/init'

module DrinkKing
  # The class is responible for routing the url
  class App < Roda
    plugin :all_verbs # allows DELETE and other HTTP verbs beyond GET/POST
    plugin :halt
    plugin :unescape_path # decodes a URL-encoded path before routing
    plugin :caching
    use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs)

    # rubocop:disable Metrics/BlockLength
    route do |routing|
      response['Content-Type'] = 'application/json'

      # GET /
      routing.root do
        message = "DrinkKing API v1 at /api/v1/ in #{App.environment} mode"

        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message: message)
        )

        response.status = result_response.http_status_code
        result_response.to_json

        # 除錯用 跑不出來就貼這段到route中，
        # 再去api_spec.rb put last_response.body
        # http_response = Representer::HttpResponse.new(result.value!)
        # response.status = http_response.http_status_code
        # result.value!.message.to_json #!!!最後一定要打to_json!!!
      end

      routing.on 'api/v1' do
        routing.on 'shops' do
          routing.on String do |search_keyword|
            # POST /api/v1/shops/{KEYWORD}
            routing.post do
              search_keyword = Request::SearchKeyword.new(search_keyword)
              result = Service::AddShops.new.call(search_keyword: search_keyword)

              Representer::For.new(result).status_and_body(response)
            end
          end

          routing.is do
            # GET /api/v1/shops?keyword={keyword}
            routing.get do
              result = Service::ListShops.new.call(search_keyword: routing.params['keyword'])

              Representer::For.new(result).status_and_body(response)
            end
          end
        end

        routing.on 'extractions' do
          routing.on String do |shopid|
            # GET /api/v1/extractions/{shopid}
            routing.get do
              Cache::Control.new(response).turn_on if Env.new(App).production?

              result = Service::ExtractShop.new.call(shop_id: shopid)

              Representer::For.new(result).status_and_body(response)
            end
          end
        end

        # GET /api/v1/menus?keyword={keyword}&searchby={shop/drink}
        routing.get 'menus' do
          Cache::Control.new(response).turn_on if Env.new(App).production?

          result = Service::ShopMenu.new.call({ keyword: routing.params['keyword'], searchby:routing.params['searchby'] })

          Representer::For.new(result).status_and_body(response)
        end
      end
    end
  end
end
