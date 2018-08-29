$ ->
  bseSettingsModule = do ->
    init: ->
      return unless $('#settings').length > 0

      $('.country-select').change ->
        target = @getAttribute 'data-target'
        targetInput = $("##{target}")[0]
        type = target.split('-')[0]
        countryCode = $("option.#{type}")[@selectedIndex - 1]
                        .getAttribute 'data-country-code'
        targetInput.value = '+' + countryCode

      $('#remove-account-checkbox').change ->
        if @checked
          $('#remove-account').removeClass 'disabled'
        else
          $('#remove-account').addClass 'disabled'

  bseSettingsModule.init()
