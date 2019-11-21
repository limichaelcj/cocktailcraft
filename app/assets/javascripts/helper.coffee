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

  validateEmptyFormField: ->
    # store semantic ui form validation params
    fields = {}
    # find each input element for name data
    $('.ui.form .validate--empty').each ->
      input = if $(this).prop('tagName').toLowerCase() == 'input' then this else $(this).find('input')[0]
      id = $(input).attr('name')
      fields[id] = 'empty'
    # execut semantic ui form validation fn
    $('.ui.form').form({ on: 'submit', fields })

  clickLoaderFor: (selector, triggerSelector) ->
    $(triggerSelector).click ->
      $(selector).append '<div class="ui active inverted dimmer"><div class="ui loader"></div></div>'
