// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require activestorage
//= require turbolinks
//= require jquery3
//= require popper
//= require bootstrap/tooltip
//= require bootstrap
//= require jquery-ui/widgets/autocomplete
//= require autocomplete-rails
//= require cookies_eu
//= require select2
//= require Chart.bundle
//= require chartkick
//= require_tree .

function enableSelect2() {
  $("select.select2n").select2({
    placeholder: "Select a card",
    allowClear: true,
    matcher: function (params, data) {
      if ($.trim(params.term) === '') {
        return data;
      }

      keywords=(params.term).split(" ");

      for (var i = 0; i < keywords.length; i++) {
        if (((data.text).toUpperCase()).indexOf((keywords[i]).toUpperCase()) == -1)
          return null;
      }
      return data;
    }
  });

  $("select.select2").select2({
    allowClear: true,
    minimumResultsForSearch: Infinity
  });
}

var i = 0;

$(document).on("turbolinks:before-cache", function () {
  $('select.select2').select2('destroy');
  $('select.select2n').select2('destroy');
});

document.addEventListener("turbolinks:load", function() {
  $("img.lazyload").lazyload();
  $('[data-toggle="tooltip"]').tooltip()

  enableSelect2();

  var navToggle = $('.js-mobile-toggle');
  var nav = $('.js-nav');
  var filters = $('.js-filters');
  var filterToggle = $('.js-filter-toggle');

  function toggleNavigation() {
    if (nav.is(':visible')) {
      nav.removeClass('nav-active');
      return false;
    }

    nav.addClass('nav-active');
  }

  function toggleFilters() {
    if (filters.find('.csearch__formwrap').is(':visible')) {
      filters.removeClass('search-active');
      return false;
    }

    filters.addClass('search-active');
  }

  function checkWindowsize() {
    var windowSize = $(window).width();

    if (windowSize > 769) {
      nav.addClass('nav-active');
    } else {
      nav.removeClass('nav-active');
    }
    if(windowSize > 501) {
      filters.removeClass('search-active');
    }
  }

  $(".link-row").click(function (e) {
    if ($(e.target).hasClass('new-window') || $(e.target).hasClass('fa-external-link')) {
      window.open($(e.target).attr("href"), '_blank');
      return false;
    }

    if (e.shiftKey || e.ctrlKey || e.metaKey || e.which === 2) {
      window.open($(this).data("href"), '_blank');
    } else {
      window.location = $(this).data("href");
    }
  });

  // Mobile Navigation
  navToggle.on('click', toggleNavigation);
  filterToggle.on('click', toggleFilters);

  $(window).resize(checkWindowsize);
  checkWindowsize();
})
