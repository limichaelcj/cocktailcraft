@jshelper =

  activateNotifications: ->
    # destroy notices after timeout
    timeout = setTimeout(
      () -> $('.notifications-box .app-notice').transition('fade')
      8000
    )

    # close notifications
    $('.message .close').on(
      'click'
      () ->
        clearTimeout(timeout)
        $(this).closest('.message').transition('fade')
    )

  stringifyErrors: (errors) ->
    return "<div class='ui negative message'><ul class='list'><li>#{errors.join('</li><li>')}</li></ul></div>"
