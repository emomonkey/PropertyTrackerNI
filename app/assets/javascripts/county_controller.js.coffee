# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("a[data-element]").click (e) ->
    velement = $(this).data("element")
    $.ajax(url: "/country_tables").done (html) ->
    $("#"+velement+"table").append html