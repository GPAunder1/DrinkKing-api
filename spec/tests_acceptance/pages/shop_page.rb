# frozen_string_literal:true

# Page object for home page
class ShopPage
  include PageObject
  page_url DrinkKing::App.config.APP_HOST + '/shop/<%=params[:keyword]>'

  div(:warning_message, id: 'flash_bar_danger')
  div(:success_message, id: 'flash_bar_success')

  div(:shop_map, id: 'maprow')
  div(:shop_list, id: 'listrow')
  button(:map_button, id:'mapbtn')
  button(:list_button, id:'listbtn')

  # elements related to shop list
  button(:shoplist_first_review_button, id:'shoplist_reviews_btn_1')
  table(:shoplist_table, id:'shop_table')
  row(:shoplist_first_shop_reviews, id:'shoplist_reviews_1')

  # elements related to shop map
  image(:marker_on_map, src: MARKER_URL, index: 1)
  div(:toast_window, id:'toast')
  div(:menu_panel, id:'menu_panel')
  div(:review_panel, id:'review_panel')
  button(:close_button, id:'closebtn')
  button(:menu_button, id:'menubtn')
  button(:review_button, id:'reviewbtn')
  button(:menu_back_button, id:'menubackbtn')
  button(:review_back_button, id:'reviewbackbtn')

  def toast_animation_done?(toast)
    toast.attribute('class').eql?('toast fade hide') || toast.attribute('class').eql?('toast fade show')
  end

  def modal_animation_done?(modal)
    modal.attribute('class') != 'collapsing'
  end

  def panel_animation_done?(panel)
    panel.attribute('style').empty? || panel.attribute('style').eql?('display: none;')
  end
end
