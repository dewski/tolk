//= require jquery
//= require jquery_ujs
//= require jquery.tablesorter
//= require bootstrap-dropdown

$(function() {
  $("table").tablesorter({ sortList: [[1,0]] });
  
  $('form[data-remote] textarea').on('keydown', function(e) {
    if (e.keyCode == 13 && !e.shiftKey) {
      $(this).parents('form').submit();
      // Won't submit disabled data if called before submit
      $(this).attr('disabled', 'disabled');
      return false;
    } else if (e.keyCode == 38) { // Up
      $(this).parents('tr').prev().find('textarea').focus();
    } else if (e.keyCode == 40) { // Down
      $(this).parents('tr').next().find('textarea').focus();
    }
  });
  
  $('a.translate').on('ajax:success', function(xhr, data, status) {
    $(this).parents('tr').find('.value textarea').attr('value', data.text).focus();
  }).on('ajax:error', function(xhr, status, error) {
    alert("There was an error translating:\n\nCode: " + status.status + "\n\nMessage:\n"+ status.statusText);
  });
  
  $('form[data-remote]').on('ajax:success', function(e) {
    $('textarea[disabled]', this).removeAttr('disabled').focus();
  }).on('ajax:error', function(e) {
    $('textarea[disabled]', this).removeAttr('disabled').focus();
  });
  
  $('table.missing-translations form[data-remote]').on('ajax:success', function(e) {
    $(this).parents('tr').remove();
  })
});
