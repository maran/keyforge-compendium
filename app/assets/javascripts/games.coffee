# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
document.addEventListener "turbolinks:load", ->
  window.dataTableGames = $("#gamesTable").DataTable(
    stateSave: true,
    "order": [[ 2, "desc" ]]
  )
document.addEventListener "turbolinks:before-cache", ->
  if window.dataTableGames != null
     window.dataTableGames.destroy()
     window.dataTableGames = null
