// features/support/angular_errors.js
window.onload = function() {
  var $injector = angular.element(document).injector();
  var $log = $injector.get('$log');

  // Raise Angular errors
  $log.error = function(error) { throw(error); };

  // Suppress Angular Logging
  $log.info = function () {};
  $log.debug = function () {};
};
