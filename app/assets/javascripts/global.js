$(document).ready(function() {

  // destroy notices after timeout
  const timeout = setTimeout(() => {
    $('.notifications-box .app-notice').transition('fade')
  }, 8000)

  // close notifications
  $('.message .close')
    .on('click', function() {
      clearTimeout(timeout)
      $(this)
      .closest('.message')
      .transition('fade')
    })
  ;


})
