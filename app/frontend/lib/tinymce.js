// Core - these two are required :-)
import 'tinymce/tinymce'
import 'tinymce/themes/modern/theme'

// Plugins
import 'tinymce/plugins/lists/plugin'
import 'tinymce/plugins/paste/plugin'
import 'tinymce-placeholder-attribute'

import 'tinymce/plugins/advlist/plugin'
import 'tinymce/plugins/autolink/plugin'
import 'tinymce/plugins/link/plugin'
import 'tinymce/plugins/image/plugin'
import 'tinymce/plugins/lists/plugin'
import 'tinymce/plugins/charmap/plugin'
import 'tinymce/plugins/print/plugin'
import 'tinymce/plugins/preview/plugin'
import 'tinymce/plugins/hr/plugin'
import 'tinymce/plugins/anchor/plugin'
import 'tinymce/plugins/pagebreak/plugin'
import 'tinymce/plugins/spellchecker/plugin'
import 'tinymce/plugins/searchreplace/plugin'
import 'tinymce/plugins/wordcount/plugin'
import 'tinymce/plugins/visualblocks/plugin'
import 'tinymce/plugins/visualchars/plugin'
import 'tinymce/plugins/code/plugin'
import 'tinymce/plugins/fullscreen/plugin'
import 'tinymce/plugins/insertdatetime/plugin'
import 'tinymce/plugins/media/plugin'
import 'tinymce/plugins/nonbreaking/plugin'
import 'tinymce/plugins/save/plugin'
import 'tinymce/plugins/table/plugin'
import 'tinymce/plugins/contextmenu/plugin'
import 'tinymce/plugins/directionality/plugin'
import 'tinymce/plugins/emoticons/plugin'
import 'tinymce/plugins/template/plugin'
import 'tinymce/plugins/paste/plugin'
import 'tinymce/plugins/textcolor/plugin'

// Skins
require.context(
  '!file?name=[path][name].[ext]&context=node_modules/tinymce!tinymce/skins',
  true,
  /.*/
)
