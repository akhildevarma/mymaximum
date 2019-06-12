// FIXME Rewrite this to work with react-md tabs

import $ from 'jquery'

var Inquiry = {
  start: function () {
    if ( !$('#js-bootstrap').data('current-user-present') ) { return }
    var $el = $('#inquiry-response-tabs .md-tab')

    function clickHandler(event) {
      var $el = $(this).find('.in-tab-item').first()
      var value = ($el.text().trim() == "All")
      if ($el.data('url')!=undefined) {
        $.ajax({
          url: $el.data('url'),
          type: 'PUT',
          data: { 'user_preferences': { 'inquiry_view_default_combined': value } },
          dataType: 'json'
        })
      }
    }
    $el.click( clickHandler )
  }
}

module.exports = Inquiry
