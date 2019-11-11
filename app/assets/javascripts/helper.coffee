getFormDataHelper = (form) ->
  formData = {}
  $(form).find('input, select').each ->
    console.log(this)
  return formData

@jshelper =

  ajaxForm: (selector, callback) ->
    form = $(selector)
    form.submit (e) ->
      e.preventDefault()
      callback getFormDataHelper(form)
