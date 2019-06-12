var subscription = require('./subscription')

var ProviderSignupsView = {
  start: function() {
      var $form = $("#new_provider_signup")
      if ($form.length > 0) {
        var $hiddenTokenField = $('#provider_signup_payment_account_stripe_card_token')
        var $last4DigitsField = $('#provider_signup_payment_account_last_four_digits')
        var allowBlank = true
        subscription.setupForm($form, $hiddenTokenField, $last4DigitsField, allowBlank)
      }
  }
}

module.exports = ProviderSignupsView
