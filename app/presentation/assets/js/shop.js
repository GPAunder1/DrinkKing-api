$(document).ready(function(){
  // $('#toast').toast('show');

  $('#listrow').hide();
  $('#menu_panel').hide();
  $('#review_panel').hide();

  $('#listbtn').click(function(){
    $('#maprow').hide();
    $('#listrow').show();
    $('#mapbtn').removeClass('active');
    $('#listbtn').addClass('active');
  });

  $('#mapbtn').click(function(){
    $('#maprow').show();
    $('#listrow').hide();
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
  $('#toast .recommend_drink').text(shop.recommend_drink);

  make_review_info(shop.reviews);
  make_menu_info(shop.menu);
}

function make_review_info(reviews){
  $('#review_info').text("");

  reviews.forEach((review, i) => {
    author = '<div>' + review.author + ' - ' + review.relative_time + '</div>';
    rating = '<div>' + "&#9733".repeat(review.rating) + '</div>'
    content ='<div>' + review.content + '</div>';
    output = author + rating + content + '</br>';
    $('#review_info').append(output);
  });
}

function make_menu_info(menu){
  $('#menu_info').text("");

  menu.forEach((drink, i) => {
    var output = '<tr>' +
                 '<td>' + drink.name + '</td>' +
                 '<td>' + drink.category + '</td>' +
                 '<td>' + drink.price.M + '</td>' +
                 '<td>' + drink.price.L + '</td>' +
                 '</tr>';

    $('#menu_info').append(output);
  });
}
