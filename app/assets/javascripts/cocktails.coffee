# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready(() ->
  $('#new-cocktail-form').form({
    on: 'blur',
    fields: {
      name: {
        identifier: 'cocktail[name]',
        rules: [
          { type: 'empty', prompt: 'Please enter a name' }
        ]
      }
    }
  })
)
