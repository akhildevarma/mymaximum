import $ from 'jquery'

var SearchFilterView = {
  start: function () {
    $(".in-filter-list-input").keyup(function() {
      var search = $(this).val();
        $(".js-result").show();
        $('.js-no-results').html('').hide()
        if (search)
          $(".js-result").not(":containsNoCase(" + search + ")").hide();
        var hiddenCount = $('.js-result:hidden').length;
        var actualCount = $('.js-items-count').html();
        if (hiddenCount==parseInt(actualCount)) {
          $('.js-no-results').html("No institution "+ '"'+search +'"' + " found.").show()
        }

    });
    $.expr[":"].containsNoCase = function (el, i, m) {
      var search = m[3];
      if (!search) {
        return false;
      }
      return new RegExp(search,"i").test($(el).text());
    };
    $(".in-filter-list-input").focus();

  }
}

module.exports = SearchFilterView
