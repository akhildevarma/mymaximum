import $ from 'jquery'

$.fn.capsWarning = function (options) {
  var $password = $(this)
  var settings = $.extend({
      // These are the defaults.
    message: 'Caps lock is on; please remember passwords are case-sensitive.',
    trigger: 'manual',
    debug: false
  }, options)

  function debug (message, object) {
    if (!settings['debug']) { return }
    console.log(message, object)
  }

  if ($.fn.tooltip) {
    var tooltipOpts = {
      trigger: settings['trigger'],
      title: settings['message']
    }
    debug('Tooltip init', tooltipOpts)
    $password.tooltip(tooltipOpts)
  } else {
    debug('ERROR')
    throw 'This plugin (jquery.capsWarning) depends on Bootstrap V3 Tooltips; please visit http://getbootstrap.com/javascript/#tooltips'
  }

  function tooltipToggle (el, setVisible) {
    var status = $(el).data('tooltip-visible')
    var shown = (status === true)
    if (typeof setVisible !== 'undefined') {
      if (!shown && setVisible) {
        $(el).tooltip('show')
      } else if (shown && !setVisible) {
        $(el).tooltip('hide')
      }
      $(el).data('tooltip-visible', setVisible)
    }
    return status
  }

  $password.keypress(function (e) {
    var $el = $(this)
    debug('Keypress')
    var key_check = e.which
    var isUp = (key_check >= 65 && key_check <= 90)
    var isLow = (key_check >= 97 && key_check <= 122)
    var key16 = key_check === 16
    var isShift = (e.shiftKey) ? e.shiftKey : key16
    if ((isUp && !isShift) || (isLow && isShift)) {
      debug('Tooltip SHOW')
      tooltipToggle($el, true)
    } else {
      debug('Tooltip HIDE')
      tooltipToggle($el, false)
    };
  })

  $password.blur(function (e) {
    debug('Tooltip HIDE')
    tooltipToggle(this, false)
  })
}

module.exports = $
