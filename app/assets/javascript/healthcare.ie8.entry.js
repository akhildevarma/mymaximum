// NOTE
// Must support all browsers IE8 and above
// =======================================

require('jquery')
require('jquery-ujs')
require('bootstrap')
//
require('chosen-js')
require('jquery.caps-warning')
require('jquery-autosize')
//
require('mustache')
//
// Styles
require('./app/ipd.inquiries.scss')
//
window.App = {}
window.App.Comments = require('./app/comments')

//
var App = function () {
  this.views = {
    comments: require('./app/comments'),
    inquiry: require('./app/inquiry'),
    provider_signups: require('./app/provider_signups'),
    search_filter: require('./app/search_filter'),
  }
}

App.prototype.start = function () {
  // send CSRF tokens for all ajax requests
  $.ajaxSetup({
    beforeSend: function (xhr) {
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
    }
  })

  $("input[ type='password' ]").capsWarning()
  $('.chosen-select').chosen()
  // Our Story page
  $('#testimonial').carousel({interval: 10000})

  $('.fa.fa-question-circle').tooltip({
    title: 'Ask us any health-related question, and if there’s evidence available, we’ll find it for you. The more specific, the better.',
    placement: 'right'
  })


  this.views.comments.start()
  this.views.inquiry.start()
  this.views.provider_signups.start()
  this.views.search_filter.start()

}

const app = new App()
document.addEventListener('DOMContentLoaded', function() {
    app.start()
}, false);

// Trigger event
// NOTE Alternatively implement synchronous loading of this script
// http://stackoverflow.com/a/2880147
var DOMContentLoaded_event = document.createEvent("Event")
DOMContentLoaded_event.initEvent("DOMContentLoaded", true, true)
window.document.dispatchEvent(DOMContentLoaded_event)
