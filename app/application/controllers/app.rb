# frozen_string_literal: true

require 'roda'

module DrinkKing
  # The class is responible for routing the url
  class App < Roda
    plugin :flash
    plugin :all_verbs # allows DELETE and other HTTP verbs beyond GET/POST
    plugin :halt
    plugin :unescape_path # decodes a URL-encoded path before routing
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

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              # result.value!.message.to_json ## test code
              Representer::ShopsList.new(result.value!.message).to_json
            end
          end

          routing.is do
            # GET /api/v1/shops?keyword={keyword}
            routing.get do
              result = Service::ListShops.new.call(search_keyword: routing.params['keyword'])

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code

              Representer::ShopsList.new(result.value!.message).to_json
            end
          end
        end

        routing.on 'extractions' do
          routing.on String do |shopid|
            # GET /api/v1/extractions/{shopid}
            # /api/v1/extractions/ChIJj-JB7XI2aDQReyt7-6gXNXk
            routing.get do
              # shop_id = Request::SearchKeyword.new(shopid)
              result = Service::ExtractShop.new.call(shop_id: shopid)
              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end
              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              result.value!.message.to_json ## test code
              # Representer::ShopsList.new(result.value!.message).to_json
            end
          end
        end

        # GET /api/v1/menus?keyword={keyword}&searchby={shop/drink}
        routing.get 'menus' do
          result = Service::ShopMenu.new.call({ keyword: routing.params['keyword'], searchby:routing.params['searchby']})
          http_response = Representer::HttpResponse.new(result.value!)
          response.status = http_response.http_status_code
          # Representer::Menu.new(result.value!.message).to_json
          result.value!.message.to_json ## test code
        end
      end
    end
  end
end

# routing.get "menus" do
#   search_word = Request::SearchKeyword.new(routing.params['keyword'])
#   result = DrinkKing::Service::Output.new.call(search_word)
#   http_response = Representer::HttpResponse.new(result.value!)
#   response.status = http_response.http_status_code
#   result.value!.message.to_json ## test code
# end

#       routing.on 'shop' do
#         routing.is do
#           # POST /shop/
#           routing.post do
#             search_word = routing.params['drinking_shop']
#             keyword_request = DrinkKing::Forms::SearchKeyword.new.call(search_keyword: search_word)
#             shops_made = DrinkKing::Service::AddShops.new.call(keyword_request)
#
#             if shops_made.failure?
#               flash[:error] = shops_made.failure
#               routing.redirect '/'
#             end
#
#             session[:search_word].insert(0, search_word).uniq!
#             # Redirect to search result page
#             routing.redirect "shop/#{search_word}"
#           end
#         end
#
#         routing.on String do |search_word|
#           # GET /shop/{search_word}
#           routing.get do
#
#             result = DrinkKing::Service::ListShops.new.call(search_keyword: search_word)
#
#             if result.failure?
#               flash[:error] = result.failure
#               routing.redirect '/'
#             else
#               shops = result.value!
#
#               display_shops = Views::ShopsList.new(shops[:shops], shops[:recommend_drinks], shops[:menu])
#             end
#
#
#             view 'shop', locals: { shops: display_shops }
#             # view 'shop', locals: { shops: shops , recommend_drinks: recommend_drinks, menu: menu}
#           end
#         end
#       end
#
#       routing.on 'test' do
#         shops = Repository::For.klass(Entity::Shop).all
#         view 'test', locals: { shops: shops }
#       end
#     end
#   end
# end
