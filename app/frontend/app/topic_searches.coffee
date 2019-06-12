$ = require('jquery')

TopicSearchesView =
  start: () ->
      $topicSearch = $("#topic-search")
      return if $topicSearch.length == 0 || $topicSearch.data("complete")

      statusUrl = $topicSearch.data("status-url")
      pollForResults = ->
        $.get(
          statusUrl,
          null,
          (data) ->
            $medlinePlus = $("#medline-plus")
            $guidelineGov = $("#guideline-gov")
            $dailyMed = $("#daily-med")
            $fda = $("#fda")
            if data.medline_plus_query_complete && !$medlinePlus.data("complete")
              $medlinePlus.data("complete", true)
              $medlinePlus.empty()
              $medlinePlus.append(Mustache.to_html($("#medline-plus-result-template").html(), medline_plus_result: data.medline_plus_result))
            if data.guideline_gov_query_complete && !$guidelineGov.data("complete")
              $guidelineGov.data("complete", true)
              $guidelineGov.empty()
              $guidelineGov.append(Mustache.to_html($("#guideline-gov-result-template").html(), guideline_gov_result: data.guideline_gov_result))
            if data.daily_med_query_complete && !$dailyMed.data("complete")
              $dailyMed.data("complete", true)
              $dailyMed.empty()
              $dailyMed.append(Mustache.to_html($("#daily-med-result-template").html(), daily_med_result: data.daily_med_result))
            if data.fda_query_complete && !$fda.data("complete")
              $fda.data("complete", true)
              $fda.empty()
              $fda.append(Mustache.to_html($("#fda-result-template").html(), fda_result: data.fda_result))
            unless data.complete
              setTimeout(
                ->
                  pollForResults()
                , 5000)
        )
      pollForResults()

module.exports = TopicSearchesView
