# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'turbolinks:load', ->
  return unless page.controller() == 'cocktails'

  # pagination on click loader init
  jshelper.clickLoaderFor('#cocktail-search', '#cocktail-search-pagination a.item')
  jshelper.clickLoaderFor('#cocktail-custom', '#cocktail-custom-pagination a.item')

  # on cocktail/remix -> submit hidden post form on anchor click
  if page.action() == 'remix'
    $('.remix-link').click (e) ->
      e.preventDefault()
      form = $('#remix-form')
      form.attr('action', $(this).attr('href'))
      form.submit()

  # on cocktail/edit -> submit hidden patch form from publish button
  if page.action() == 'edit'
    $('#publish-link').click (e) ->
      e.preventDefault()
      $('#publish-form').submit()
