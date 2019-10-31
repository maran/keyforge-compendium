# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'turbolinks:load', ->
  input = $('.js-rules-search');
  rule = $('.js-rules li');
  rules = $('.js-rules');
  resultText = $('.js-results');
  copyLink = $('.js-copy-link');
  toggleNav = $('.js-toggle-glossary');
  results = [];

  # Mobile nav toggle
  toggleNav.on 'click', ->
    rules.toggleClass('visible');

  # Copy hotlink to clipboard
  copyLink.on 'click', ->
    copyText = $(this).parent().find('input');
    copyText.select();
    document.execCommand("copy");

    alert = $('<span class="global-alert">Copied To Clipboard</span>');
    $('body').append(alert)

    setTimeout ( ->
      $('.global-alert').remove();
    ), 2000

  # Append Scroll Top Button
  $(window).on 'scroll', ->
    if $(window).scrollTop() > 250
      scrollToTop = '<i class="scroll-top fa fa-angle-up"></i>';

      if $('.scroll-top').length == 0
        $('body').append(scrollToTop);

    else
      $('.scroll-top').remove();

  # Scroll Top Action
  $('body').on 'click', '.scroll-top', ->
    window.scrollTo(0, 0);

  # Jump to anchor on page without reloading
  rule.find('a').on 'click', (e) ->
    hash = $(this).attr('href');

    location.hash = hash;
    e.preventDefault();

  # Create array of each rule
  $.each rule, (i) ->
    res = {
      value: $(rule[i]).find('a').text().toLowerCase(),
      target: $(rule[i]).find('a').attr('data-id')
    }

    results.push(res);

  # Filter rules by input value
  input.on 'keyup keydown keypress blur change', ->
    lng = input.val().length;
    val = input.val().toLowerCase();

    if lng > 2
      $('.kfc-rule').addClass('hidden');

      $.each rule, (i) ->
        $(rule[i]).addClass('hidden');

      filteredResults = results.filter (i) ->
        $.trim(i.value).includes($.trim(val));

      searchValue = '<strong>' + val + '</strong>';

      if filteredResults.length == 0
        resultText.html('Sorry we found no results for ' + searchValue).addClass('no-results');
      else
        resultLength = '<strong>' + filteredResults.length + '</strong>';

        resultText.html('Displaying ' + resultLength + ' result(s) for ' + searchValue);

      $.each filteredResults, (i) ->
        id = filteredResults[i].target;

        $('*[data-id='+id+']').parent().removeClass('hidden');
        $('#'+id+'').removeClass('hidden');

    else
      $('.kfc-rule').removeClass('hidden');
      resultText.removeClass('no-results').html('');

      $.each rule, (i) ->
        $(rule[i]).removeClass('hidden');

