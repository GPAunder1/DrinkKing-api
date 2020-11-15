$(document).ready(function(){
  // $('#toast').toast('show');

  $('#list').hide();
  $('#menu_panel').hide();
  $('#review_panel').hide();

  $('#listbtn').click(function(){
    $('#maprow').hide();
    $('#list').show();
    $('#mapbtn').removeClass('active');
    $('#listbtn').addClass('active');
  });

  $('#mapbtn').click(function(){
    $('#maprow').show();
    $('#list').hide();
    $('#listbtn').removeClass('active');
    $('#mapbtn').addClass('active');
  });

  $('#menubtn').click(function(){
    $('#menu_panel').show("slide", {
      direction: "right"
    }, 500);
  })

  $('#reviewbtn').click(function(){
    $('#review_panel').show("slide", {
      direction: "right"
    }, 500);
  })

  $('#menubackbtn').click(function(){
    $('#menu_panel').hide("slide", {
      direction: "right"
    }, 500);
  })

  $('#reviewbackbtn').click(function(){
    $('#review_panel').hide("slide", {
      direction: "right"
    }, 500);
  })
});

function make_toast_info(shop){
  $('#toast .name').text(shop.name);
  $('#toast .address').text(shop.address);
  $('#toast .phone_number').text(shop.phone_number);
  $('#toast .opening_now').text(shop.opening_now);
  $('#toast .rating').text(shop.rating);
  // $('#toast .recommend_drink').text();

  make_review_info(shop);
}

function make_review_info(shop){
  $('#review_info').text("");

  shop.reviews.forEach((review, i) => {
    author = '<div>' + review.author + ' - ' + review.relative_time + '</div>';
    rating = '<div>' + "&#9733".repeat(review.rating) + '</div>'
    content ='<div>' + review.content.replace(/<br\/>/g, " ") + '</div>';
    output = author + rating + content + '</br>';
    $('#review_info').append(output);
  });

}
