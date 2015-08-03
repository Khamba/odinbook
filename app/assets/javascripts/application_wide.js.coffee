jQuery ->
  $(window).on 'scroll resize contentSizeReduced', ->
    # Move Header for horizontal scroll
    $('.header-holder').css 'left', -$(this).scrollLeft() + "px"

    # Infinite scroll with pagination
    if $('.pagination').length
      url = $('.pagination .next_page').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 200
        $('.pagination').empty().append('<div class="loading"></div>')
        $('.loading').append('<span></span>').append('<span>Loading...</span>')
        $.getScript url

  $(window).scroll()

  # Prevent search on an empty string
  $('.header-form').on 'click', 'button', (event) ->
    return false if $('#q').val().trim() is ""


  # Substitute default browser confirmation dialog with jQuery UI's
  $.rails.allowAction = (link) ->
    return true unless link.attr 'data-confirm'
    $.rails.showConfirmDialog link
    false

  $.rails.confirmed = (link) ->
    link.removeAttr 'data-confirm' 
    link.trigger 'click.rails'

  $.rails.showConfirmDialog = (link) ->
    message = link.attr 'data-confirm'
    html = """
           <div id="dialog-confirm" title="WARNING!">
             <p>#{message}</p>
           </div>
           """
    $(html).dialog
      resizable: false
      modal: true
      width: 350
      buttons: 
        "I'm Sure": ->
          $.rails.confirmed link
          $(this).dialog "close"
        Cancel: -> 
          $(this).dialog "close"
