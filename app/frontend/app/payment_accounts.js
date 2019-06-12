var subscription = require('./subscription')

var PaymentAccountsView = {
  start: function () {
    var $form = $("[id*=edit_payment_account]")
    if ($form.length > 0) {
      var $hiddenTokenField = $("#payment_account_stripe_card_token")
      var $last4DigitsField = $("#payment_account_last_four_digits")
      var allowBlank = true
      subscription.setupForm($form, $hiddenTokenField, $last4DigitsField, allowBlank)
    }
  }
}
module.exports = PaymentAccountsView
