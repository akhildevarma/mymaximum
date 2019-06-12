import $ from 'jquery'
import '../lib/tinymce'

var myinterval; 
var autosave_url;

function auto_save(url) {
  var editor = tinymce.activeEditor;
  if (editor.isDirty()) {
    var content = editor.getContent();
    $.ajax({
        type: "POST",
        url: url,
        data: { summary_table : { body_html: content} },
        cache: true,
        async: false,   //prevents mutliple posts during callback
        success: function (msg) {
          $('#summary_table_body_html').attr('data-auto-save-url', msg.url);
        }
    });
  }
  else {
    return false;
  }
}
var SummaryTablesView = {
  

  start: function () {
    tinymce.init({
      selector: '#summary_table_body_html',
      statusbar: true,
      style_formats:[{title:'Headings', items:[{title:'Header 5',format:'h5'},{title:'Header 6',format:'h6'}]},{title:'Inline',items:[{title:'Bold',icon:'bold',format:'bold'},{title:'Italic',icon:'italic',format:'italic'},{title:'Underline',icon:'underline',format:'underline'},{title:'Strikethrough',icon:'strikethrough',format:'strikethrough'},{title:'Superscript',icon:'superscript',format:'superscript'},{title:'Subscript',icon:'subscript',format:'subscript'},{title:'Code',icon:'code',format:'code'}]},{title:'Blocks',items:[{title:'Paragraph',format:'p'},{title:'Blockquote',format:'blockquote'},{title:'Div',format:'div'},{title:'Pre',format:'pre'}]},{title:'Alignment',items:[{title:'Left',icon:'alignleft',format:'alignleft'},{title:'Center',icon:'aligncenter',format:'aligncenter'},{title:'Right',icon:'alignright',format:'alignright'},{title:'Justify',icon:'alignjustify',format:'alignjustify'}]}],
      plugins: [
          'advlist autolink link image lists charmap print preview hr anchor pagebreak',
          'searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking',
          'save table contextmenu directionality emoticons template paste textcolor'
        ],
      setup: function (ed) {  //start a 5 second timer when an edit is made do an auto-save 
            ed.on('change keyup', function (e) {
                clearInterval(myinterval);
               myinterval = setInterval(function () {
                  autosave_url =  $('#summary_table_body_html').attr('data-auto-save-url');
                  auto_save(autosave_url);
                }, 10000);
                
            });
        }
    });

    $('#clear-btn').click(function() {
      tinymce.activeEditor.setContent('')
    });

     $('#load-btn').click(function() {
      tinymce.activeEditor.setContent('<p>&nbsp;</p><table><tbody><tr><td colspan="5"><p><em><span style="font-weight: 400;">Enter title in bold, normal size font without a reference number</span></em></p></td></tr><tr><td><p><span style="font-weight: 400;">Design</span></p></td><td colspan="4"><p><em><span style="font-weight: 400;">Objective terms describing the type of study (randomized, uncontrolled, retrospective, placebo-controlled, cross-over</span></em><strong><em>, etc.);</em></strong><em><span style="font-weight: 400;"> N= (total subjects</span></em><em><span style="font-weight: 400;">)</span></em></p></td></tr><tr><td><p><span style="font-weight: 400;">Objective</span></p></td><td colspan="4"><p><em><span style="font-weight: 400;">State the objective (purpose) of the study using the author&rsquo;s language</span></em></p></td></tr><tr><td><p><span style="font-weight: 400;">Study Groups</span></p></td><td colspan="4"><p><em><span style="font-weight: 400;">Only the separate groups and their cohort number (n) should be listed. You can describe more details of the cohorts in the methods section so this section can stay very succinct.</span></em></p></td></tr><tr><td><p><span style="font-weight: 400;">Methods</span></p></td><td colspan="4"><p><em><span style="font-weight: 400;">Include relevant inclusion/exclusion criteria (not a comprehensive list), data collection, clinical statistics, and any other information needed to understand the results. Any loose ends from all other sections are tied up here, as concisely as possible.</span></em></p></td></tr><tr><td><p><span style="font-weight: 400;">Duration</span></p></td><td colspan="4"><p><em><span style="font-weight: 400;">Include the duration of the trial as a whole, as well as the duration of the interventions.</span></em></p></td></tr><tr><td><p><span style="font-weight: 400;">Outcome Measures</span></p></td><td colspan="4"><p><em><span style="font-weight: 400;">If the primary outcome measure isn&rsquo;t explicit from the study, all outcome measures applicable to the inquiry can be listed in this section. If the primary outcome measure is explicit, then make separate sections for &lsquo;Primary&rsquo; and &lsquo;Secondary&rsquo; Outcome Measures. &nbsp;</span></em></p><br /><p><em><span style="font-weight: 400;">All outcome measures listed should correlate directly/exactly with the results presented later.</span></em></p></td></tr><tr><td rowspan="6"><p><span style="font-weight: 400;">Baseline Characteristics</span></p></td><td>&nbsp;</td><td><p><span style="font-weight: 400;">A</span></p></td><td><p><span style="font-weight: 400;">B</span></p></td><td><p><span style="font-weight: 400;">Placebo</span></p></td></tr><tr><td><p><span style="font-weight: 400;">Age, years</span></p></td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td><p><span style="font-weight: 400;">Women </span></p></td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td><p><span style="font-weight: 400;">White</span></p></td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td><p><span style="font-weight: 400;">--- </span></p></td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td colspan="4"><p><em><span style="font-weight: 400;">Include relevant baseline characteristics</span></em><span style="font-weight: 400;"> that will provide a general (big picture) view of the patients in the study.</span></p></td></tr><tr><td rowspan="4"><p><span style="font-weight: 400;">Results</span></p></td><td><p><span style="font-weight: 400;">Endpoint</span></p></td><td><p><span style="font-weight: 400;">A</span></p></td><td><p><span style="font-weight: 400;">B</span></p></td><td><p><span style="font-weight: 400;">Placebo</span></p></td></tr><tr><td><p><span style="font-weight: 400;">----</span></p></td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td><p><span style="font-weight: 400;">p-value vs placebo</span></p></td><td><p><span style="font-weight: 400;">p&lt; </span></p></td><td><p><span style="font-weight: 400;">p&lt; </span></p></td><td>&nbsp;</td></tr><tr><td colspan="4"><p><em><span style="font-weight: 400;">All results listed should correlate directly/exactly with the outcome measures presented previously.</span></em> <em><span style="font-weight: 400;">Results that do not have to do with the inquiry should not be included; just the stated outcomes need corresponding results. </span></em></p><br /><p><em><span style="font-weight: 400;">Tables are encouraged to display the most info using the least space/words.</span></em></p></td></tr><tr><td rowspan="3"><p><span style="font-weight: 400;">Adverse Events</span></p></td><td colspan="4"><p><span style="font-weight: 400;">Common Adverse Events: </span><em><span style="font-weight: 400;">(</span></em><span style="font-weight: 400;">or those deemed frequent; </span><em><span style="font-weight: 400;">if not listed in study, use N/A or &ldquo;Not disclosed&rdquo;)</span></em></p></td></tr><tr><td colspan="4"><p><span style="font-weight: 400;">Serious Adverse Events: </span><em><span style="font-weight: 400;">(or those deemed high risk; if not listed in study, use N/A or &ldquo;Not disclosed&rdquo;)</span></em></p></td></tr><tr><td colspan="4"><p><span style="font-weight: 400;">Percentage that Discontinued due to Adverse Events: </span><em><span style="font-weight: 400;">(if not listed in study, use N/A or &ldquo;Not disclosed&rdquo;)</span></em></p></td></tr><tr><td><p><span style="font-weight: 400;">Study Author Conclusions</span></p></td><td colspan="4"><p><em><span style="font-weight: 400;">Include author&rsquo;s conclusions on the question at hand, using full sentences. Don&rsquo;t include any conclusions that don&rsquo;t correspond to results we list. </span></em></p></td></tr><tr><td><p><span style="font-weight: 400;">InpharmD Researcher Critique</span></p></td><td colspan="4"><p><em><span style="font-weight: 400;">As the expert, add 1-2 sentences on strengths, weaknesses, and takeaways from this study.</span></em></p></td></tr></tbody></table><p><br /><br /></p>')
    })
  }
}

module.exports = SummaryTablesView
