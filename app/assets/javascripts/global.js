// use .on(turbolinks:load) instead of .ready
$(document).on('turbolinks:load', ready)

function ready(){
  handleNotificationsBox();
  imageUploadPreview();
  initSemantic();
}

function handleNotificationsBox(){
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
}

function imageUploadPreview(){
  $('.image-upload-preview').on('change', function(){
    if (this.files && this.files[0]){
      const target = $(`#${this.id}-preview`)[0]
      target.classList.remove('hide')
      target.innerHTML = `<div style="position:relative;height:100%;width:100%;"><div class="ui active loader"></div></div>`
      const reader = new FileReader();
      reader.readAsDataURL(this.files[0]);
      reader.onload = function(e){
        const img = document.createElement('img')
        img.src = e.target.result
        Object.assign(img.style, {
          height: '100%',
          width: '100%',
        })
        target.innerHTML = '';
        target.append(img);
      }
    }
  })
}

function initSemantic(){
  $('.ui.accordion').accordion();
  $('select.dropdown').dropdown();
}
