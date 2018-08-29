$ ->
  bseOrdersModule = do ->
    init: ->
      return unless $('#orders').length > 0

      $('.order-row').click ->
        window.location = $(@).data 'link'

  bseOrdersModule.init()

