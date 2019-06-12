import $ from 'jquery'
require('../lib/jquery.best-in-place')
  // COMMENTS
var Comments = {

  start: function () {
    var commentsListQuery = ".in-comments-list"
    var replyFormQuery = "[data-id='in-comment-reply-form']";
    var commentItemQuery = "[data-id='in-comment']";
    var replyToggleQuery = "[data-id='in-comment-reply-form-toggle']";
    var commentItemQuery = ".in-comments-list-item"
    var listIndex = undefined;

    function initializeCommentItem( index, commentEl ){
      var $commentEl = $(commentEl)
      var $replyToggle = $commentEl.find(replyToggleQuery).first();
      var $replyForm = $commentEl.find(replyFormQuery).first();
      var uid = "in-comment-reply-form" + "-" + listIndex + "-" + index + "-" + Math.floor((Math.random() * 10000) + 1) + "-" + Math.floor((Math.random() * 10000) + 1);
      $replyForm.attr( "id", uid );
      $replyToggle.attr( "data-target", "#" + uid )
    }

    function initializeCommentLists(){
      $(commentsListQuery).each( function( index, listEl ){
        var $listEl = $(listEl)
        listIndex = index;
        $listEl.find(commentItemQuery).each( initializeCommentItem )
      });
    }

    function initializeBestInPlace(){
      $(commentItemQuery).find('.best_in_place').best_in_place();
    }

    function initializeComposer(){
      $("form.in-comments-composer").bind('ajax:success', function(event, data, status, xhr) {
        event.target.reset();
      });
    }

    function initializeFlagAction(){
      $("[data-action='flag-comment']").bind('ajax:before', function(event,data,status,xhr) {
        var $target = $(event.target).closest('.in-comments-list-item').slideUp(400, function(){
          $target.remove()
        })
        return true
      });
    }

    function initializeCollapseToggle(){
      $(replyFormQuery).collapse( { toggle: false } )
    }

    function initializeCommentsCount(){
      var $discussionTitles = $('.discussions .response-document-page-section-title, .discussions-tab-item')
      var commentsCounts = $(commentsListQuery).first().find(commentItemQuery).length
      $discussionTitles.each(function( index, titleEl ){
        var $title = $(titleEl)
        listIndex = index;
        $title.html('Discussion ('+commentsCounts+')')
      })
    }

    initializeCommentLists();
    initializeCollapseToggle();
    initializeBestInPlace();
    initializeFlagAction();
    initializeComposer();
    initializeCommentsCount();

    // END--COMMENTS--
  }
}

module.exports = Comments
