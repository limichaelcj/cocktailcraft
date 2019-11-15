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

  # only on cocktail/edit page
  if page.action() == 'edit'
    $('#dose-form').form({
      on: 'submit',
      fields: {
        ingredient: {
          identifier: 'ingredient',
          rules: [
            { type: 'empty', prompt: 'Please enter an ingredient' }
          ]
        },
        amount: {
          identifier: 'dose[amount]',
          rules: [
            { type: 'empty', prompt: 'Please specify an amount' }
          ]
        }
      }
    })

  if page.action() == 'remix'
    $('.remix-link').click (e) ->
      e.preventDefault()
      form = $('#remix-form')
      alert($(this).attr('href'))
      form.attr('action', $(this).attr('href'))
      form.submit()
