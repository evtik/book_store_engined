$ ->
  bseBooksModule = do ->
    init: ->
      return unless $('#books').length > 0 or $('#reviews').length > 0

      $('.img-link').click (e) ->
        e.preventDefault()
        $('#main-image').attr 'src', @getAttribute 'data-image'

      $('.quantity-decrement').click (e) ->
        e.preventDefault()
        targetInput = $ "##{@getAttribute 'data-target'}"
        quantity = parseInt targetInput.val()
        targetInput.val(quantity - 1) if quantity > 1

      $('.quantity-increment').click (e) ->
        e.preventDefault()
        targetInput = $ "##{@getAttribute 'data-target'}"
        quantity = parseInt targetInput.val()
        targetInput.val(quantity + 1)

      $('#book-description').trunk8
        lines: 6
        tooltip: false
        fill: '&hellip; <a class="in-gold-500" id="read-more" ' +
              "href='#'>#{I18n.t('books.book_details.read_more')}</a>"

      $(document).on 'click', '#read-more', ->
        $(@).parent().trunk8('revert').append("<a class='in-gold-500' " +
          "id='read-less' href='#'>#{I18n.t('books.book_details.read_less')}</a>")
        false

      $(document).on 'click', '#read-less', ->
        $(@).parent().trunk8()
        false

      $('.review-star').hover ->
        for i in [1..5]
          $("#star-#{i}").addClass 'rate-empty'
        index = starIndex @
        for i in [1..index]
          $("#star-#{i}").removeClass 'rate-empty'
      , ->
        for i in [1..5]
          starElement = $("#star-#{i}")
          if starElement.hasClass 'star-checked'
            starElement.removeClass 'rate-empty'
          else
            starElement.addClass 'rate-empty'

      $('.review-star').click ->
        index = starIndex @
        for i in [1..index]
          $("#star-#{i}").addClass 'star-checked'
        if index < 5
          for i in [(index + 1)..5]
            $("#star-#{i}").removeClass('star-checked').addClass('rate-empty')
        $('#review_score').val index

      starIndex = (element) -> parseInt element.id.split('-')[1]

  bseBooksModule.init()
