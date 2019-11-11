class Page
  controller: () =>
    $('meta[name=psjs]').attr('controller')
  action: () =>
    $('meta[name=psjs]').attr('action')

@page = new Page
