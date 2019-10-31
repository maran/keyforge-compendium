# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

document.addEventListener "turbolinks:load", ->
  window.dataTable = $("#favDecks").DataTable(stateSave: true)

document.addEventListener "turbolinks:before-cache", ->
  if window.dataTable != null
     window.dataTable.destroy()
     window.dataTable = null
