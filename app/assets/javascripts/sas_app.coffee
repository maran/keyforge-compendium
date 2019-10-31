$(document).on 'turbolinks:load', ->
  deck_id = $("#sasApp").attr("data-id")
  if deck_id != undefined
    $.get "/decks/#{deck_id}/sas",(e)->
      if e.sasRating != undefined
        $("#sasRating").html(e.sasRating)
        $("#sasRatingText").html('SAS <p>'+e.sasRating+'<p>')
        $("#cardRating").html('Cards Rating <p>'+e.cardsRating+'<p>')
        $("#synergy").html('Synergy <p>'+e.synergyRating+'<p>')
        $("#antiSynergy").html('Anti Synergy <p>'+e.antisynergyRating+'<p>')
      else
        $("#sasData").hide();
        $("#sasFail").html("SAS rating could not be retrieved.")

      $("#sasWaiting").hide();
