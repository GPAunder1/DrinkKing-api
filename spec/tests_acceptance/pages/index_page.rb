# frozen_string_literal:true

# Page object for home page
class IndexPage
  include PageObject

  page_url DrinkKing::App.config.APP_HOST

  div(:warning_message, id: 'flash_bar_danger')
  div(:success_message, id: 'flash_bar_success')

  h1(:title_heading, id: 'main_header')
  text_field(:keyword_input, id: 'drinking_shop_input')
  button(:search_button, id: 'repo-form-submit')
  table(:shops_table, id: 'shops_table')
  div(:search_record_card_body, id: 'search_record_card_body')

  indexed_property(
    :records,
    [
      [:div, :record, { id: 'record_%s'}]
    ]
  )

  def first_record
    records[0]
  end

  def search_keyword(keyword)
    self.keyword_input = keyword
    self.search_button
  end
end
