require('jquery')

Interventions =
  start: () ->
    $('#intervention-yes').click ->
      $('#intervention_taken').val('true')
      $('#intervention-response-container').show()

module.exports = Interventions
