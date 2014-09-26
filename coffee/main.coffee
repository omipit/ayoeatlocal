$ ->
  # console.log "on"
  
  if(!(/Android|iPhone|iPad|iPod|BlackBerry|Windows Phone/i).test(navigator.userAgent or navigator.vendor or window.opera))
    skrollr.init
      forceHeight: false


  instaTag = "ayoeatlocal"
  instaPosts = "9"
  recentMediaUrl = "https://api.instagram.com/v1/tags/#{instaTag}/media/recent?client_id=7ef247949c684b6a9ee95c076e60c53b&count=#{instaPosts}"

  # $('.intro-slide .introduce').each((i, elem) ->
  #   $(elem).delay(i * 3400).fadeOut(400).next().fadeIn(400)
  # )

  $(".owl-carousel").owlCarousel(
    items: 1
    autoplay: 1
    autoplayTimeout: 9000
    animateIn: 1
    animateOut: 'fadeOut'
    loop: 1
    touchDrag: false
    pullDrag: false
    mouseDrag: false
  )

  adjustSliderImageSize = ->
    height = $("#intro").outerHeight()
    $('.bg-image .image').css('min-height': "#{height}px")

  adjustSliderImageSize()
  $(window).on('resize', adjustSliderImageSize)

  # Build navigation
  $('.nav-able').each (index, elem) ->
      id      =   $(elem).attr('id')
      title   =   $(elem).attr('data-nav-name')
      $("#main-nav ul").append("<li><a href='##{id}' class='section-#{id} anchor' data-title='#{title}'><span class='dot'></span></a></li>");

  # check which navable is active and notify navigation

  $("#main-nav li a").hover(
    (ev) ->
      labelOffset = $(@).parent().position().top
      labelTxt = $(@).attr('data-title')
      $("#main-nav .label").stop(true).animate('top': "#{labelOffset}px", 350, ->
        $(@).text(labelTxt)
      )
    (ev) ->
      labelOffset = $("#main-nav .active").parent().position().top
      labelTxt = $("#main-nav .active").attr('data-title')
      $("#main-nav .label").stop(true).animate('top': "#{labelOffset}px", 350, ->
        $(@).text(labelTxt)
      )
  )

  changeNav = (elem) ->
      id = elem.attr('id')
      $("#main-nav a").removeClass('active')
      $("#main-nav").find(".section-#{id}").addClass('active')
      labelOffset = $("#main-nav .active").parent().position().top
      labelTxt = $("#main-nav .active").attr('data-title')
      $("#main-nav .label").stop(true).animate('top': "#{labelOffset}px", 500).text(labelTxt)

      # check if white-bg 
      # console.log elem.attr('data-bg-color')
      if elem.attr('data-bg-color')?
          bgClass = elem.attr('data-bg-color')
          $('#main-nav').removeClass()          
          $('#main-nav').addClass(bgClass)
      else
          $('#main-nav').removeClass()
          # $('body').removeClass('white-bg')

  $('.nav-able').waypoint(
      handler: (direction) ->
          if direction is "down"
              changeNav($(@))
      offset: ->
           return 200;
  ).waypoint(
      handler: (direction) ->
          if direction is "up"
              changeNav($(@))
      offset: ->
          return -200;
  )




  instagramUrl = ""
  fetchInsta = (url) ->
    # console.log url
    fetching_user_photos = $.ajax
      dataType : "jsonp"
      url : url
      success: (data) ->
        $("#instagram").find('.loading').remove()
        # console.log "finished getting pictures..."
        # Iterate over found instagram item in data
        # console.log data
        instagramUrl = data.pagination.next_url ? ""
        $.each(data.data, (i, item) ->
          thumbnail = item.images.thumbnail.url
          thumbnail_width = item.images.thumbnail.width
          thumbnail_height = item.images.thumbnail.height
          full_image = item.images.standard_resolution.url
          link = item.link
          videoAttr = ""
          videoClass = ""
          videoIcon = ""
          videoHtml = ""
          user = item.user.username
          # console.log item
          # append images and
          $("<a target='_blank' href='#{link}' data-full-image='#{full_image}' class='insta-thumb #{videoClass}'>
            <div class='wrap'>
              <div class='overlay'>
                <i class='icon-instagram'></i>
                  <span class='username'>#{user}</span>
              </div>
              <img width='100%' height='100%' src='#{thumbnail}'/>
              </div></a>").appendTo('.instagram-posts').hide().delay(400*i).fadeIn(400)
          )

        if instagramUrl isnt ""
          $(".load-more-wrap .button").show(400)
          # after appending images, show the load more if
        else
          $(".load-more-wrap .button").fadeOut(400)


	# execute fetchInsta function
  fetchInsta(recentMediaUrl)
  $(".load-more-wrap").on('click', '.button', () ->
    fetchInsta(instagramUrl)
    return false
  )

  $('body').on 'click', 'a.anchor', () ->
    target = $($(@).attr('href'))
    $('html,body').animate({
      scrollTop: target.offset().top
      }, 1000)
    return false