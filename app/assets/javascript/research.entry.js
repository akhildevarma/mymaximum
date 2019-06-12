import $ from 'jquery'
require('jquery-ujs')
require('bootstrap')

require('chosen-js')
require('local-time')
require('jquery.caps-warning')
require('jquery-autosize')

require('chartkick')
require('highcharts')
require('mustache')
require('jquery.truncate')

// Styles
require('./app/ipd.inquiries.scss')
//
window.App = {}
window.App.Comments = require('./app/comments')
//
var App = function () {
  this.views = {
    comments: require('./app/comments'),
    inquiries: require('./app/inquiries'),
    subscription: require('./app/subscription'),
    interventions: require('./app/interventions'),
    payment_accounts: require('./app/payment_accounts'),
    provider_signups: require('./app/provider_signups'),
    search_filter: require('./app/search_filter'),
    summary_tables: require('./app/summary_tables'),
    topic_searches: require('./app/topic_searches')
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
  this.views.inquiries.start()
  this.views.subscription.start()
  this.views.interventions.start()
  this.views.payment_accounts.start()
  this.views.provider_signups.start()
  this.views.search_filter.start()
  this.views.summary_tables.start()
  this.views.topic_searches.start()
//
}
//
//
//
const app = new App()
document.addEventListener('DOMContentLoaded', function() {
    app.start()
}, false);
