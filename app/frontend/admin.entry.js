import $ from 'jquery'
require('jquery-ujs')
require('bootstrap')

require('chosen-js')
require('local-time')
require('jquery-autosize')
require('chartkick')
require('highcharts')
require('mustache')
require('jquery.truncate')
//
// // Styles
require('./app/ipd.inquiries.scss')

window.App = {}
//
var App = function () {
  this.views = {
    inquiries: require('./app/inquiries'),
    search_filter: require('./app/search_filter'),
    summary_tables: require('./app/summary_tables'),
    team_admin_logo_cropper: require('./app/team_admin_logo_cropper')
    //)
  }
}

App.prototype.start = function () {
  // send CSRF tokens for all ajax requests
  $.ajaxSetup({
    beforeSend: function (xhr) {
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
    }
  })

  $('.chosen-select').chosen()

  this.views.inquiries.start()
  this.views.search_filter.start()
  this.views.summary_tables.start()
  this.views.team_admin_logo_cropper.start()
}
//
//
//
const app = new App()
document.addEventListener('DOMContentLoaded', function() {
    app.start()
}, false);
