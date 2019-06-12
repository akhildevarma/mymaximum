
require 'jquery'
require 'typeahead.js'
Bloodhound = require 'bloodhound-js'
require 'bootstrap-tagsinput/dist/bootstrap-tagsinput.js'
require 'bootstrap-tagsinput/dist/bootstrap-tagsinput.css'
require 'bootstrap-tagsinput/dist/bootstrap-tagsinput-typeahead.css'
require '../lib/tinymce'

InquiriesView = {
  elements: [
    # '#inquiry_relevant_prescribing_info'
    # '#inquiry_review_of_other_tertiary_literature'
    # '#inquiry_search_strategy'
    # '#inquiry_custom_response_text'
    # '#inquiry_review_of_clinical_guidelines'
    # '#inquiry_review_of_meta_analyses'
    # '#inquiry_review_of_review_articles'
    # '#inquiry_background_references'
    #'#inquiry_level_of_evidence'
  ],
  initAutocomplete: () ->
    return unless $("#inquiry_tag_list").length > 0
    $inquiryTagList = $("#inquiry_tag_list")
    inquiryId = $inquiryTagList.data('inquiry-id')
    tagsIndexUrl = $inquiryTagList.data("autocomplete-url")

    tags = new Bloodhound
      datumTokenizer: Bloodhound.tokenizers.whitespace
      queryTokenizer: Bloodhound.tokenizers.whitespace
      dupDetector: (remoteMatch, localMatch) ->
        remoteMatch.id == localMatch.id
      prefetch: tagsIndexUrl
      limit: 10
      remote:
        url: tagsIndexUrl + '?query=%QUERY',
        wildcard: '%QUERY',
        filter: (response) ->
          response.data.results

    tags.initialize();

    $inquiryTagList.tagsinput
        typeaheadjs:
          name: 'tags'
          hint: true,
          highlight: true,
          minLength: 1,
          source: tags.ttAdapter()
          # source: (query, sync, async) ->
          #   results = tags.search query, sync, async
          #   results

    $inquiryTagList.on 'beforeItemAdd', (event) ->
      tag = event.item
      ajaxData =
        inquiry_id: inquiryId
        tag_name: tag
      if !event.options or !event.options.preventPost
        $.ajax tagsIndexUrl,
          data: ajaxData,
          type: 'POST'
          complete: (response) ->
            if response.failure
              $('#tags-input').tagsinput 'remove', tag, preventPost: true
            return
      return

    $inquiryTagList.on 'beforeItemRemove', (event) ->
      tag = event.item
      ajaxData =
        inquiry_id: inquiryId
        tag_name: tag
      if !event.options or !event.options.preventPost
        $.ajax tagsIndexUrl,
          data: ajaxData,
          type: 'DELETE'
          complete: (response) ->
            if response.failure
              $('#tags-input').tagsinput 'add', tag, preventPost: true
            return
      return

  initTinyMCE: () ->
    $.each this.elements, (index, value) ->
      tinymce.init
        selector: value
        menubar: true
        removed_menuitems: 'newdocument'
        statusbar: true
        toolbar: false #'undo redo | bold italic underline'
        plugins: [
          'advlist autolink link image lists charmap print preview hr anchor pagebreak',
          'searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking',
          'save table contextmenu directionality emoticons template paste textcolor'
        ]

        resize: 'both'
        setup: (theEditor) ->
            toolbarsQuery = ".mce-toolbar, div.mce-toolbar-grp, .mce-statusbar"
            theEditor.on "init", ->
              $(theEditor.contentAreaContainer.parentElement).find(toolbarsQuery).hide()
            theEditor.on 'focus', ->
              $(theEditor.contentAreaContainer.parentElement).find(toolbarsQuery).show()
            theEditor.on 'blur', ->
              $(theEditor.contentAreaContainer.parentElement).find(toolbarsQuery).hide()
      return
  start: () ->
      this.initAutocomplete()
      this.initTinyMCE()
      $('#clear-btn').click ->
        tinymce.activeEditor.setContent ''
        return
      $('#copy-evidence-btn').click ->
        tinymce.activeEditor.setContent '<table style=\"height: 125px;\" width=\"835\">\r\n<tbody>\r\n<tr>\r\n<td style=\"width: 138px;\">\r\n<h4><strong>Level</strong></h4>\r\n</td>\r\n<td style=\"width: 155px;\">\r\n<h4><strong>Therapy / Prevention, Aetiology / Harm</strong></h4>\r\n</td>\r\n<td style=\"width: 152px;\">\r\n<h4><strong>Prognosis</strong></h4>\r\n</td>\r\n<td style=\"width: 152px;\">\r\n<h4><strong>Diagnosis</strong></h4>\r\n</td>\r\n<td style=\"width: 156px;\">\r\n<h4><strong>Differential diagnosis / symptom prevalence study</strong></h4>\r\n</td>\r\n<td style=\"width: 153px;\">\r\n<h4><strong>Economic and decision analyses</strong></h4>\r\n</td>\r\n</tr>\r\n<tr>\r\n<td style=\"width: 138px;\">&nbsp;</td>\r\n<td style=\"width: 155px;\">&nbsp;</td>\r\n<td style=\"width: 152px;\">&nbsp;</td>\r\n<td style=\"width: 152px;\">&nbsp;</td>\r\n<td style=\"width: 156px;\">&nbsp;</td>\r\n<td style=\"width: 153px;\">&nbsp;</td>\r\n</tr>\r\n</tbody>\r\n</table>'
        return
      $('#use-research-question').click ->
        $('#inquiry_title').val $('#inquiry_researchable_question').val()
        return
}

module.exports = InquiriesView
