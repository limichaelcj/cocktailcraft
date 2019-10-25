$(document).ready(function() {

  // close notifications
  $('.message .close')
    .on('click', function() {
      $(this)
      .closest('.message')
      .transition('fade')
    })
  ;

  // destroy notices after timeout
  setTimeout(() => {
    $('.notifications-box .app-notice').transition('fade')
  }, 8000)

})
