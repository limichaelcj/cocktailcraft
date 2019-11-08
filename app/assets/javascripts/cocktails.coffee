# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'turbolinks:load', ->
  return unless page.controller() == 'cocktails'

  validateCocktailForm = ->
    $('#cocktail-form').form({
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

  # run script
  validateCocktailForm()
