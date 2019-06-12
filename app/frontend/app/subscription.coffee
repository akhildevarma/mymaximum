require 'jquery'

Subscription =
  setupForm: ($form, $hiddenTokenField, $last4DigitsField, allowBlank) ->
    Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
    $form.submit ->
      $cardNumber = $("[data-stripe=number]")
      # when the card number field is empty, don't call back unless allowBlank is false
      return true if (allowBlank && !$cardNumber.val()) || $hiddenTokenField.val()

      $('input[type=submit]').attr('disabled', true)

      Stripe.createToken($(this), subscription.handleStripeResponse($form, $hiddenTokenField, $last4DigitsField))
      false

  handleStripeResponse: ($form, $hiddenTokenField, $last4DigitsField) ->
    return (status, response) ->
      if status == 200
        $hiddenTokenField.val(response.id)
        $last4DigitsField.val(response.card.last4)
        $form[0].submit()
      else
        $('#stripe_errors').text(response.error.message)
        $('input[type=submit]').attr('disabled', false)

  start: () ->
    return true

module.exports = Subscription
