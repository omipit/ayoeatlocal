$(function() {
  var adjustSliderImageSize, changeNav, fetchInsta, instaPosts, instaTag, instagramUrl, recentMediaUrl;
  console.log("on");
  if (!/Android|iPhone|iPad|iPod|BlackBerry|Windows Phone/i.test(navigator.userAgent || navigator.vendor || window.opera)) {
    skrollr.init({
      forceHeight: false
    });
  }
  instaTag = "ayoeatlocal";
  instaPosts = "9";
  recentMediaUrl = "https://api.instagram.com/v1/tags/" + instaTag + "/media/recent?client_id=7ef247949c684b6a9ee95c076e60c53b&count=" + instaPosts;
  $(".owl-carousel").owlCarousel({
    items: 1,
    autoplay: 1,
    autoplayTimeout: 9000,
    animateIn: 1,
    animateOut: 'fadeOut',
    loop: 1,
    touchDrag: false,
    pullDrag: false,
    mouseDrag: false
  });
  adjustSliderImageSize = function() {
    var height;
    height = $("#intro").outerHeight();
    return $('.bg-image .image').css({
      'min-height': "" + height + "px"
    });
  };
  adjustSliderImageSize();
  $(window).on('resize', adjustSliderImageSize);
  $('.nav-able').each(function(index, elem) {
    var id, title;
    id = $(elem).attr('id');
    title = $(elem).attr('data-nav-name');
    return $("#main-nav ul").append("<li><a href='#" + id + "' class='section-" + id + " anchor' data-title='" + title + "'><span class='dot'></span></a></li>");
  });
  $("#main-nav li a").hover(function(ev) {
    var labelOffset, labelTxt;
    labelOffset = $(this).parent().position().top;
    labelTxt = $(this).attr('data-title');
    return $("#main-nav .label").stop(true).animate({
      'top': "" + labelOffset + "px"
    }, 350, function() {
      return $(this).text(labelTxt);
    });
  }, function(ev) {
    var labelOffset, labelTxt;
    labelOffset = $("#main-nav .active").parent().position().top;
    labelTxt = $("#main-nav .active").attr('data-title');
    return $("#main-nav .label").stop(true).animate({
      'top': "" + labelOffset + "px"
    }, 350, function() {
      return $(this).text(labelTxt);
    });
  });
  changeNav = function(elem) {
    var bgClass, id, labelOffset, labelTxt;
    id = elem.attr('id');
    $("#main-nav a").removeClass('active');
    $("#main-nav").find(".section-" + id).addClass('active');
    labelOffset = $("#main-nav .active").parent().position().top;
    labelTxt = $("#main-nav .active").attr('data-title');
    $("#main-nav .label").stop(true).animate({
      'top': "" + labelOffset + "px"
    }, 500).text(labelTxt);
    console.log(elem.attr('data-bg-color'));
    if (elem.attr('data-bg-color') != null) {
      bgClass = elem.attr('data-bg-color');
      $('#main-nav').removeClass();
      return $('#main-nav').addClass(bgClass);
    } else {
      return $('#main-nav').removeClass();
    }
  };
  $('.nav-able').waypoint({
    handler: function(direction) {
      if (direction === "down") {
        return changeNav($(this));
      }
    },
    offset: function() {
      return 200;
    }
  }).waypoint({
    handler: function(direction) {
      if (direction === "up") {
        return changeNav($(this));
      }
    },
    offset: function() {
      return -200;
    }
  });
  instagramUrl = "";
  fetchInsta = function(url) {
    var fetching_user_photos;
    console.log(url);
    return fetching_user_photos = $.ajax({
      dataType: "jsonp",
      url: url,
      success: function(data) {
        var _ref;
        $("#instagram").find('.loading').remove();
        console.log(data);
        instagramUrl = (_ref = data.pagination.next_url) != null ? _ref : "";
        $.each(data.data, function(i, item) {
          var full_image, link, thumbnail, thumbnail_height, thumbnail_width, user, videoAttr, videoClass, videoHtml, videoIcon;
          thumbnail = item.images.thumbnail.url;
          thumbnail_width = item.images.thumbnail.width;
          thumbnail_height = item.images.thumbnail.height;
          full_image = item.images.standard_resolution.url;
          link = item.link;
          videoAttr = "";
          videoClass = "";
          videoIcon = "";
          videoHtml = "";
          user = item.user.username;
          console.log(item);
          return $("<a target='_blank' href='" + link + "' data-full-image='" + full_image + "' class='insta-thumb " + videoClass + "'> <div class='wrap'> <div class='overlay'> <i class='icon-instagram'></i> <span class='username'>" + user + "</span> </div> <img width='100%' height='100%' src='" + thumbnail + "'/> </div></a>").appendTo('.instagram-posts').hide().delay(400 * i).fadeIn(400);
        });
        if (instagramUrl !== "") {
          return $(".load-more-wrap .button").show(400);
        } else {
          return $(".load-more-wrap .button").fadeOut(400);
        }
      }
    });
  };
  fetchInsta(recentMediaUrl);
  $(".load-more-wrap").on('click', '.button', function() {
    fetchInsta(instagramUrl);
    return false;
  });
  return $('body').on('click', 'a.anchor', function() {
    var target;
    target = $($(this).attr('href'));
    $('html,body').animate({
      scrollTop: target.offset().top
    }, 1000);
    return false;
  });
});

//# sourceMappingURL=main.js.map
