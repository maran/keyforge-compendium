# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  # Toggle Advanced Search
  toggle_advanced = $('.js-toggle-advanced')
  advanced = $('.js-advanced-search')
  checkbox = $('.js-checkbox').find('input[type="checkbox"]');
  sortby = $('.js-trigger-filter');

  toggleAdvanced = () ->
    if advanced.hasClass('active')
      advanced.removeClass('active')
      toggle_advanced.text('Advanced Search')
    else 
      advanced.addClass('active')
      toggle_advanced.text('Hide Advanced Search')

  toggleCheckbox = (e) ->
    if $(e.target).is(':checked')
      $(e.target).parent().addClass('activecb');
    else
      $(e.target).parent().removeClass('activecb');

  checkbox.on "change", (e) ->
    toggleCheckbox(e);

  toggle_advanced.on "click", () ->
    toggleAdvanced();

  sortby.on "change", () ->
    $('#filterrific_filter').submit();

  $("#checkAllTags").on 'click', (e)->
    $(".tagsSelector").prop("checked", false);
    $(".tagsSelector").trigger("click")
    e.preventDefault()

  $("#uncheckAllTags").on 'click', (e)->
    $(".tagsSelector").prop("checked",true);
    $(".tagsSelector").trigger("click")
    e.preventDefault()


  $(".tagsSelector").on "change", (e)->
    id = $(e.currentTarget).val()
    if this.checked
      $("#tagCollection-"+id).show()
    else
      $("#tagCollection-"+id).hide()

  $('#newCategory').on 'hide.bs.collapse', ->
    $('#categoriesOverview').show()
    $('#decks_user_category_attributes_name').prop("disabled", true)
    $('#decks_user_category_id').prop("disabled", false)

  $('#newCategory').on 'show.bs.collapse', ->
    $('#categoriesOverview').hide()
    $('#decks_user_category_id').prop("disabled",true)
    $('#decks_user_category_attributes_name').prop("disabled", false)

  $("#favouriteDeck").on "click", (e)->
    $.post "/decks_users", {id: $(e.currentTarget).attr("data-deck-id")}, (data) ->
      if data == true
        $("#favouriteDeck").addClass("active")
      else
        $("#favouriteDeck").removeClass("active")
