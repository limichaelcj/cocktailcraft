// use .on(turbolinks:load) instead of .ready
$(document).on('turbolinks:load', ready)

function ready(){
  handleNotificationsBox();
  imageUploadPreview();
  initSemantic();
  formValidation();
}

function handleNotificationsBox(){
  // destroy notices after timeout
  jshelper.activateNotifications();
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
  // $('.ui.accordion').accordion();
  $('.ui.radio.checkbox').checkbox();
  $('.ui.dropdown').dropdown();
  $('.popup-trigger').popup({
    inline: true,
    on: 'click'
  })
}

function formValidation(){
  jshelper.validateEmptyFormField()
}
